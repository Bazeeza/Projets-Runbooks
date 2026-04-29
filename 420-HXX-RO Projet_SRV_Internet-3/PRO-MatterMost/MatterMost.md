# Travail Pratique 2.3 – AWS RDS + MatterMost
**Auteur But et Schéma planification**

| Élément        | Contenu                                                                        |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Référent**   | Présentation et documentation d’un serveur **Mattermost** hébergé sur AWS et relié à une base de données **AWS RDS PostgreSQL**.              |
| **Émetteur**   | **Abdul-Bariu. Abdul-Majid. Aran**                   |
| **Message**    | Présenter et documenter les **résultats** du déploiement réseau et services DNS, TLS, RDS et notifications e-mail) de **Mattermost**.   |
| **Récepteur**  | M. Jérémy Massinon      |
| **Canal**      | Dépôt GitLab                |
| **Code**       | La langue française   |
| **Références** | [MatterMost Docs](https://docs.mattermost.com/index.html) [EC2 DOCS](https://docs.aws.amazon.com/fr_fr/ec2/), [AWS RDS DOCS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html)|

---

## Déploiement et configuration du serveur Mattermost

**Explication**

Le service **Mattermost** est une plateforme de messagerie et collaboration d'equipe qui pour ce TP est déployé sur l’instance **EC2** et exposé au public. L’application écoute **en interne** sur le port de base **8065** non exposé à Internet.

**Après le déploiement**

* L’interface Web est accessible via le **nom de domaine sans port** : `https://mattermost-azeez.ddns.net`.
* Authentification et création de **teams/canaux** fonctionnelles ; **messages** échangés entre comptes de l’équipe.
* **Notifications e-mail** opérationnelles via **SMTP Gmail** (`smtp.gmail.com:587`, **STARTTLS**, App Password).
* Connexion base de données : **AWS RDS PostgreSQL** (endpoint privé), **TLS** activé côté client avec **CA RDS**.

---
* Vérification Db-RDS ainsi que détaille de la base de données connecté (le endpoint est surligner en jaune)
---
![Image 16](https://i.postimg.cc/pTSLNqH1/Screenshot-2025-10-24-at-6-16-08-PM.png)
---
* Authentification du endpoint par rapport au db-RDS sur AWS
* Authentification, comme vous pouvez le constaté que le endpoint id est le meme que celui créer de base.
---
![Screenshot 2025-10-28 17:42:28](https://i.postimg.cc/mg5Tpcvp/Screenshot-2025-10-28-174228.png)
---
* Vérification utilisateur BD et détaille de sa connexion + Type de BD = PostgreSQL
---
![Image 19](https://i.postimg.cc/hjYtFpB6/Screenshot-2025-10-24-at-6-29-46-PM-2.png)
---
* Vérification du **statut du service** `mattermost.service`.
---
![Image 15](https://i.postimg.cc/26tSp2Yp/Screenshot-2025-10-24-at-6-14-18-PM.png)
---
* Interface Web Mattermost (page de connexion / espace de travail).
---
![Image 011](https://i.postimg.cc/nzrhwN6M/Screenshot-2025-10-24-at-4-27-12-PM.png)
---
* Conversation montrant des **messages** tests entre membres.
---
![Image 20](https://i.postimg.cc/DZNwVBhy/Screenshot-2025-10-24-at-6-52-40-PM.png)
---

## DNS et HTTPS

Nous avons lié un **nom de domaine dynamique** via **No-IP** pour accéder au service sans utiliser l’adresse IP.

| Élément                   | Détail                                                          |
| ------------------------- | --------------------------------------------------------------- |
| **Fournisseur DNS**       | No-IP                                                           |
| **Nom de domaine (FQDN)** | `mattermost-azeez.ddns.net`                                     |
| **Adresse IP publique**   | `3.209.116.82`                                                  |
| **Statut DNS**            | Actif et fonctionnel                                            |
| **Certificat TLS**        | Let’s Encrypt (déployé via Certbot), renouvellement automatique |

**Pourquoi ces choix ?**

* No IP est utile pour respectée le FQDN de notre DNS public qui pointe vers `3.209.116.82`.
* Let's Encrypt est utilisé pour sécuriser les sites web en fournissant gratuitement des certificats SSL/TLS.
* Donc ici elle permet de passer du HTTP au HTTPS, afin de chiffrer les données de communication de Mattermost entre le site.
* Ajotons aussi qu'elle est gratuit, facile à configurer + le renouvellement automatisé
---
* Tableau No-IP ou résolution DNS (`A → 3.209.116.82`).
---
![Image 1](https://i.postimg.cc/43B3PXFx/Screenshot-2025-10-24-at-2-05-02-PM.png)
---
* Navigateur sur `https://mattermost-azeez.ddns.net` avec cadenas.
---
![Image 5](https://i.postimg.cc/5tntgfkw/Screenshot-2025-10-24-at-4-29-04-PM.png)
---
* Détails du **certificat** (issuer, Serveur CN et dates).
---
![Image 6](https://i.postimg.cc/50y2kDZC/Screenshot-2025-10-24-at-4-30-38-PM.png)
---
![Image 10](https://i.postimg.cc/G2tmS6ZX/Screenshot-2025-10-24-at-6-08-30-PM.png)
---
![Image 11](https://i.postimg.cc/d13VSgzg/Screenshot-2025-10-24-at-6-11-03-PM.png)
---
![Image 2](https://i.postimg.cc/DzBz67YW/Screenshot-2025-10-24-at-2-54-00-PM.png)
---

## Résumé d’architecture

* **Application** : Mattermost **11.0.2**.
* **URL du site** : `https://mattermost-azeez.ddns.net` (sans port).
* **Adresse IP publique EC2** : `3.209.116.82`.
* **Base de données** : **AWS RDS PostgreSQL**
  * **Endpoint** : `db-rds.cd4kugqmkipx.us-east-1.rds.amazonaws.com`
  * **Port** : `5432`
  * **Classe d’instance** : `db.t3.micro`
  * **Publicly accessible** : **NON**
* **Chiffrement Web** : **HTTPS Let’s Encrypt** 
* **Courriels** : **SMTP Gmail** (`smtp.gmail.com:587`, **STARTTLS**, App Password). --- **configuration incomplet**
* **Fonctionnel** : accès public sans port, messagerie entre membres, notifications e-mail, base sur RDS, certificat valide.

---

## Résultats création de comptes
* Résultats attendus
---
* **Compte 1** : `aranmattermost@gmail.com` - reçoit les notifications, connexion au workspace fonctionnelle.
---
![Image 20](https://i.postimg.cc/DZNwVBhy/Screenshot-2025-10-24-at-6-52-40-PM.png)
---
* **Compte 2** : `azeezmattermost@gmail.com` - reçoit les notifications, connexion au workspace fonctionnelle.
---
![Image 8](https://i.postimg.cc/LX580Gr0/Screenshot-2025-10-24-at-4-45-15-PM.png)
---


## Reverse proxy et notifications

* **Chemin applicatif** : `/opt/mattermost`
* **Service** : `mattermost.service` (systemd), utilisateur `mattermost`
* **Port applicatif** : `8065` (écoute **locale** uniquement)
* **NGINX** : vhost pour `mattermost-azeez.ddns.net`, `proxy_pass` vers `http://127.0.0.1:8065`, **WebSockets** activés
---
* Conclusion : pour ce TP la configuration du SMTP n'a pas été  résusi pour la notifications de Courriels des nos compte utilisateur, par contre on vous confrime que les comptes sont fonctionnelle. 
---
