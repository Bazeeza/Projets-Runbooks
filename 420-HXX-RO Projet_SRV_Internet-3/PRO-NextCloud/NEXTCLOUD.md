# Travail Pratique 2 – Déploiement serveur Nextcloud + Stockage AWS S3
**Auteur But et Schéma de planification**

| Élément        | Contenu                                                                 |
|----------------|-------------------------------------------------------------------------|
| **Référent**   | Présentation et documentation  d’un serveur Nextcloud + Certs (Let's Encrypt) et enfin avec une stockage AWS S3  |
| **Émetteur**   | **Abdul-Bariu. Abdul-Majid. Aran**                                      |
| **Message**    | Présenter et documenter les résultats de notre installation et la déploiement dune instance Ubuntu Server sur AWS et Nextcloud avec certs             |
| **Récepteur**  | **M. Jérémy Massinon**                                                  |
| **Canal**      | Un dépôt GitLab                                                         |
| **Code**       | La langue française                                                     |
| **Référence**  | Consultez la [Documentation](https://faq.teclib.com/fr/03_knowledgebase/procedures/install_glpi/) |

---

### Création et configuration de l’instance EC2

- Une instance Ubuntu Server 24.04 LTS a été créée dans la région us-east-1.  
- Version ubuntu : **Ubuntu Server 24.04 LTS**
- Adresse publique : 54.83.127.219  
- Adresse privée : 172.31.31.66
- Type de l'instance: **t3.small**
---
- Cela montre que l’environnement Cloud Labs fournit toutes les informations nécessaires : type d'instance et la version
---
![Capture 1](https://i.postimg.cc/tJgwtCVZ/1.png)
---
![Capture 2](https://i.postimg.cc/3NwVCJDG/2.png)
---

### Installation des dépendances et de Nextcloud

Connexion SSH à l’instance et installation des paquets apache2 et autres installation pour le fonctionement :

```
sudo apt update
sudo apt install apache2 php libapache2-mod-php mariadb-server unzip wget -y
```
---
- Voici une suite preuves d'éxecution de l'installtion des dépendances mariadb, apache2, sqllite, php et mysql
- Ces intallation seront nécessaire pour le fonctionement de notre serveur
---
![Capture 13](https://i.postimg.cc/d30pmtT6/13.png)
---
![Capture 7](https://i.postimg.cc/sx2q9DZP/7.png)
---
![Capture 3](https://i.postimg.cc/D0zHdyb4/3.png)
---
![Capture 4](https://i.postimg.cc/mkrJN2FC/4.png)
---
![Capture 4-1](https://i.postimg.cc/VvNpBLbb/4-1.png)
---
![Capture 4-2](https://i.postimg.cc/4y3qbNh9/4-2.png)
---
![Capture 5](https://i.postimg.cc/C5KXHLfj/5.png)
---
![Capture 6](https://i.postimg.cc/Y0SZfqm6/6.png)
---

```
sudo apt install python3-certbot-apache -y
```
**Explication de la commande**
- Ici, c'est l'installation python3-certbot-apache Certbot pour avoir un cert en https pour nos page web.
- Cette commande permet de générer des certificats SSL automatiquement via Let's Encrypt.
---
- Capture - Installation python3-certbot-apache (Certbot)  
---
![Capture 13](https://i.postimg.cc/d30pmtT6/13.png)
---

### Téléchargement et configuration de Nextcloud

Téléchargement avec wget par la suite il faut faire unzip nextcloud :

```
wget https://download.nextcloud.com/server/releases/nextcloud-28.0.3.zip
unzip nextcloud-28.0.3.zip -d /var/www/
chown -R www-data:www-data /var/www/nextcloud
```
---
- Voici une suite preuves d'éxecution de l'installation
---
![Capture 8](https://i.postimg.cc/KjYwrvgr/8.png)
---
- Voici ici capture --- Contenu du dossier /var/www/nextcloud (On trouve ici les fichiers index.php, config, apps, etc.)
---
![Capture 9](https://i.postimg.cc/4y3qbNhQ/9.png)
---

### Configuration du VirtualHost Apache

- Création du fichier /etc/apache2/sites-available/nextcloud.conf :

```
<VirtualHost *:80>
    ServerName aran.servebeer.com
    DocumentRoot /var/www/nextcloud
    <Directory /var/www/nextcloud/>
        AllowOverride All
    </Directory>
</VirtualHost>
```
- Activation du site et Vérification de son status :  
```
sudo a2ensite nextcloud.conf
sudo systemctl reload apache2
sudo systemctl status apache2
```
---
- Voici une suite preuves d'éxecution de l'installation
- Capture du Fichier VirtualHost aran.servebeer.com activé
----
![Capture 15](https://i.postimg.cc/QCMwkxWf/15.png)
----

### Configuration du DNS dynamique (No-IP)

- Création d’un domaine dynamique : **aran.servebeer.com**  
- Outil utilisé : No-IP  
- Notre domaine est liée à notre adresse publique AWS.  
---
---
- Voici une suite preuves d'éxecution de l'installation
---
![Capture 14](https://i.postimg.cc/fybpjT0B/14.png)
---
- Voici ici une suite de caputre du tableau de bord No-IP  
- Voici ici une suite de caputre du client No-IP installé et configuré sur Ubuntu
---
![Capture 12](https://i.postimg.cc/SRK37NzV/12.png)
---

### Installation de Nextcloud via navigateur

Depuis le navigateur tapez votre address publique :  
- 54.83.127.219 ou bien http://aran.servebeer.com
    - veuilez noter que c'est normale que la page n'est pas encore sécurisé.

Configuration :  
- Admin : nextcloud  
- Mot de passe : nextcloud123$  
- Base : SQLite (pour simplifier)  
---
- Capture -- Page d’installation Nextcloud  
---
![Capture 10](https://i.postimg.cc/gjB5MFvR/10.png)
---
- Capture -- Tableau de bord initial après installation (Application Récommandées)
---
![Capture 11](https://i.postimg.cc/wMBZcTsk/11.png)
---

### Résolution du domaine non approuvé

- Lors de l’accès avec le nom de domaine, Nextcloud affichait :  
- **Accès à partir d’un domaine non approuvé**

- Correction af aire dans la page PHP /var/www/nextcloud/config/config.php :

```
'trusted_domains' =>
array (
  0 => '54.83.127.219',
  1 => 'aran.servebeer.com',
),
```
---
- Voici ici le fichier config.php de base
---
![Capture 16](https://i.postimg.cc/8cn3yQhB/16.png)
---
- Voici ici une capture de la modification du fichier config.php
---
![Capture 17](https://i.postimg.cc/0jH3tRp7/17.png)
---

### Sécurisation HTTPS avec Certbot

- Commande à exécutée :
```
sudo certbot --apache -d aran.servebeer.com --register--unsafely-without-email
```
**Explication**

- Certbot est un programme open source qui automatise la renouvellement et la demande des certificats SSL/TLS
- Ici avec cette commande l'installer d'un certificat SSL/TLS gratuit de **Let's Encrypt** pour notre serveur web Apache.
- Le certificat **Let’s Encrypt** a été obtenu et activé automatiquement.  
---
- Voici ici la capture de la commande et l'installation de Certbot réussie
----
![Capture 18](https://i.postimg.cc/2yXJHR4h/18.png)
----
- Voici ici la capture de la commande à éxecuter pour l'enregistrement sans email
---
![Capture 20](https://i.postimg.cc/FznqP5jy/20.png)
---
- Le site est maintenant en https://aran.servebeer.com :
    - Sécurisé avec certs en HTTPS
    - Acessible publiquement
---
- Voici ici une capture du site Nextcloud avec HTTPS valide
---
![Capture 21](https://i.postimg.cc/L507yKzQ/21.png)
---
### Configuration du stockage externe S3

**Dans Paramètres → Administration → Stockage externe :  **
- Type : Amazon S3  
- Dossier : AmazonS3  
- Région : us-east-1  
- Nom du bucket : tp2mpb  
- AccessKey : ***************************  
- SecretKey : *************************** 
- SSL activé
---
- Voici ici une capture --- Panneau de configuration Nextcloud (stockage externe S3)
---
![Capture 24](https://i.postimg.cc/nrw5dbvR/24.png)
---
- Voici ici une capture --- Dossier AmazonS3 visible avec cred_s3.txt dans Nextcloud
---
![Capture 25](https://i.postimg.cc/gjB5MFvB/25.png)
---

### Vérification dans la console AWS

**Dans notre console AWS → S3 → tp2mpb :  **
Veuillez confirmer que le fichier cred_s3.txt est bien visible dans le bucket.  

- Cela confirme que Nextcloud a réussi à écrire sur S3.
- Connecté à AWS S3  
- Opérationnel avec utilisateur et stockage fonctionnel  
---
- Voici ici tel que demandée une capture AWS S3 console – Fichier cred_s3.txt  
---
![Capture 2](https://i.postimg.cc/prCHB6TR/c2.png)
---
![Capture 3](https://i.postimg.cc/cChScbHd/c3.png)---
---