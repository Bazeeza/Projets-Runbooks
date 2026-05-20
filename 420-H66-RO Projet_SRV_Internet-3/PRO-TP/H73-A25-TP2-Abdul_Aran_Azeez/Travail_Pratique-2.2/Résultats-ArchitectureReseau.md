# Travail Pratique 2.2 – AWS Architecture Reseau + Groupe de sécurité  
**Auteur But et Schéma planification**

| Élément        | Contenu                                                                 |
|----------------|-------------------------------------------------------------------------|
| **Référent**   | Présentation et documentation d’un serveur Jellyfin hébergé sur AWS sécurisé avec HTTPS, et supervisé via AWS CloudWatch. |
| **Émetteur**   | **Abdul-Bariu. Abdul-Majid. Aran**                                      |
| **Message**    | Présenter et documenter les résultats complets de l’installation et du déploiement de Jellyfin avec sa supervision CloudWatch sur AWS. |
| **Récepteur**  | M. Jérémy Massinon                                                  |
| **Canal**      | Un dépôt GitLab                                                         |
| **Code**       | La langue française                                                     |
| **Référence**  | Consultez la [Documentation officielle AWS EC2](https://docs.aws.amazon.com/fr_fr/ec2/) et [Jellyfin Docs](https://jellyfin.org/docs/). |

---
### Architecture Réseautique et Configuration Base

- Une instance **Ubuntu Server 24.04 LTS**.  
- Type d’instance : **t3.small**  
- **Adresse IPv4 publique : 54.227.166.166**  
- **Adresse IPv4 privée : 172.31.30.137**  
---
- Résultat - Capture détails techniques de l’instance  
---
![cap 2](https://i.postimg.cc/MH62pcng/Screenshot-2025-10-21-at-7-35-50-PM.png)
---

### Résultats Groupe de sécurité

**Voici les ports ouverts sur la machine :  **

| Type              | Protocole | Port | Source     | Description |
|-------------------|-----------|------|-------------|--------------|
| **SSH**           | TCP       | 22   | 0.0.0.0/0   | Permet connexion distant sécurisée sur le serveur. |
| **HTTP**          | TCP       | 80   | 0.0.0.0/0   | Permet accéder à la page web et vers HTTPS. |
| **HTTPS**         | TCP       | 443  | 0.0.0.0/0   | Permet un accès sécurisé avec SSL. |
| **TCP personnalisé pour Jellyfin** | TCP | 8096 | 0.0.0.0/0 | utilisation par la service Jellyfin. |

---
### Pourquoi ces règles ?

- Le port **22 (SSH)** ici est essentiel pour la connexion sur machine et faire les Configuration nécessaire.
- Le port **80 (HTTP)** ici est requis pour la redirection vers une page web securisé.
- Le port **443 (HTTPS)** ici est utilisé pour le chiffrement par SSL du site.
- Le port **8096** ici est le point de demarrage pour Jellyfin afin acceder à son interface web.  
---
- Résultat - Capture des règles de sécurité AWS  
---
![cap 3](https://i.postimg.cc/Fzr5HfYq/Screenshot-2025-10-21-at-7-37-35-PM.png)
---
