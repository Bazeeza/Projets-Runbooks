# Travail Pratique 2.3 – Architecture Reseau Mattermost + AWS RDS
**Auteur But et Schéma planification**

| Élément        | Contenu                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Référent**   | Présentation et documentation d’un serveur **Mattermost** hébergé sur AWS et relié à une base de données **AWS RDS PostgreSQL**.                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| **Émetteur**   | **Abdul-Bariu. Abdul-Majid. Aran**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **Message**    | Présenter et documenter les **résultats** de la partie réseau VPC, DNS, TLS, groupes de sécurité, et accès RDS.                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| **Récepteur**  | M. Jérémy Massinon                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| **Canal**      | Dépôt GitLab                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| **Code**       | La langue française                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| **Références** | [MatterMost Docs](https://docs.mattermost.com/index.html) [EC2 DOCS](https://docs.aws.amazon.com/fr_fr/ec2/), [AWS RDS DOCS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html)|


### Configuration du VPC

* **VPC** : `vpc-01cacd1ef26e91987`
* **Sous-réseaux RDS (DB Subnet Group `rds-ec2-db-subnet-group-1`)** :
* **Principe** : RDS déployé en **sous-réseaux privés** du VPC (instance **non publique**), EC2 en sous-réseau permettant une **IP publique** pour l’accès web.
* **Vers** : Internet: http-https = EC2 (80/443) = proxy NGINX = Mattermost Port (localhost:8065) = RDS (TLS `5432`, privé au VPC).
---
* vue VPC/Subnet group/attachements SG.
---
![test e](https://i.postimg.cc/ZqYycWdk/Screenshot-2025-10-28-193737.png)
---

### Instance EC2 MatterMost
* **Système** : Ubuntu Server **24.04 LTS** (voir capture)
* **Adresse IP publique** : `3.209.116.82` (voir capture)
* **Nom de domaine** : `mattermost-azeez.ddns.net` (No-IP)
* **Type d’instance EC2** : `t3.small` (voir capture)
* **Ports exposés publiquement** : **80/443** uniquement (NGINX).
* **Port applicatif Mattermost** : **8065** (boucle locale `127.0.0.1:8065`, non exposé Internet).

* **Pourquoi ces choix ?**
  * **24.04 LTS** : la conformité et elle mache correctement sur les versions récentes de NGINX/systemd.
  * **t3.small** : réserve CPU/ram suffisante pour Mattermost, pour les coûts aws et extensible si charge.
  * **Exposition ver NGINX** : terminaison TLS, redirection HTTP=HTTPS, support WebSockets, masquage du port interne 8065.
---
* Détails instance (type, IP publique, AZ, VPC, Subnet)
---
![Screenshot 2025-10-28 18:42:10](https://i.postimg.cc/vZNG2gRR/Screenshot-2025-10-28-184210.png)
---
* SG EC2 (règles inbound/outbound)
---
![Screenshot 2025-10-28 18:43:43](https://i.postimg.cc/5tQbh4JD/Screenshot-2025-10-28-184343.png)
---


### Instance RDS PostgreSQL

* **Moteur** : PostgreSQL version 14.19
* **Type** : `db.t3.micro`
* **Endpoint** : `db-rds.cd4kugqmkipx.us-east-1.rds.amazonaws.com`
* **Port** : `5432`
* **Publicly accessible** : **NON**
* **Security Group RDS (inbound)** : **5432** autorisé **uniquement** depuis le **Security Group de l’EC2** (accès privé intra-VPC).

* **Pourquoi ces choix ?**
  * **PostgreSQL** : Ici le moteur officiellement supporté par Mattermost elle choisir pour sa compatiblilité. Ajoutons aussi que le TLS activé côté client pour chiffrer et authentifier la DB RDS via la CA `rds-ca-rsa2048-g1`.
    * Elle est auusi connu pour ses offres des performances pour les opérations d'écriture en HA, ce qui est le cas pour Mattermost.
    * Selon la politique de Mattermost à partir de la version Mattermost v10.6, la version minimale requise sera de PostgreSQL 13.
    * Mattermost avait deja abandonner la DB de MySQL à partir de la version 11. Ils ne mettent plus activement et travailont pas sur la prise en charge de MySQL. [Références Politique MatterMost DOCS](https://mattermost.com/blog/mattermost-postgresql-support-policy/)
  * **db.t3.micro** : Ici selon le documentation officelle chez AWS cette taille est suffisant pour l'installtion ainsi que pour notre TP d'un petite groupe. On n'a pas aussi la possibilité d’augmenter puisque notre compte sont des comptes du type étudiant.
  * **Port 5432 ** : Ici c'est le port sortant de notre instance EC2  qui autorise la connexion, port connu de base mais pour notre tp elle n'est pas accessible au public.
---
- Partie RDS Connectivity et Security (endpoint) 
--- 
![rds 3](https://i.postimg.cc/0QjtFyLM/rds3.png)
---
- RDS - Configuration moteur PostgreSQL
---
![rds 2](https://i.postimg.cc/pTr04Lgn/rds2.png)
---
- Type classe
---
![rds 1](https://i.postimg.cc/6QYjMv18/rds.png)
---
- Résultats Finaux instance RDS 
---
![Screenshot 2025-10-28 17:44:29](https://i.postimg.cc/13jy7nxZ/Screenshot-2025-10-28-174429.png)
---
- Résultats Finaux RDS  Connectivity et Security (endpoint, port = 5432) 
---
![Screenshot 2025-10-28 17:46:13](https://i.postimg.cc/rwPqZ06k/Screenshot-2025-10-28-174613.png)
---

### Résultats Groupe Sécurité EC2 MatterMost

**Ports ouverts sur l’instance EC2**

| Type  | Protocole | Port | Source    | Description                                                            |
| ----- | --------- | ---- | --------- | ---------------------------------------------------------------------- |
| SSH   | TCP       | 22   | 0.0.0.0/0 | Administration distante sécurisée pour SSH. |
| HTTP  | TCP       | 80   | 0.0.0.0/0 | Entrée HTTP, redirigée vers HTTPS.                           |
| HTTPS | TCP       | 443  | 0.0.0.0/0 | Entrée HTTPS par un certificat public.                   |

* **Pourquoi ces choix ?**
  * **8065** n’est pas ouvert publiquement. Mattermost écoute localement derrière NGINX.
  * **RDS:5432** Sortant EC2 autorise la connexion
--
- Security Groups (inbound/outbound)](captures/ec2-sg.png)`
---
![Screenshot 2025-10-28 18:43:43](https://i.postimg.cc/5tQbh4JD/Screenshot-2025-10-28-184343.png)
---

### Résultats Groupe de Sécurité - RDS(PostgreSQL)

**Autorisations d’entrée sur l’instance RDS**

| Type       | Protocole | Port | Source SG autorisée                                 | Description                                      |
| ---------- | --------- | ---- | --------------------------------------------------- | ------------------------------------------------ |
| PostgreSQL | TCP       | 5432 | **Security Group EC2** (ex. `sg-02f700513e7a35954`) | Autorise seulement l’EC2 à se connecter à la DB. |

* **Pourquoi ces choix ?**
  * Aucun port 22/80/443 n’est ouvert sur RDS.
  * TCP est ouvert que pour la base de données
---
- Connectivity & Security (inbound 5432 depuis SG EC2)](captures/rds-connectivity.png)
---
![Screenshot 2025-10-28 17:46:13](https://i.postimg.cc/rwPqZ06k/Screenshot-2025-10-28-174613.png)
---