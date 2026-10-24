# Configuration MySQL et GLPI sur Ubuntu Serveur

#### Auteur But et Schéma de planification

| Élément        | Contenu                                                                 |
|----------------|-------------------------------------------------------------------------|
| **Référent**   | Présentation et documentation de l’installation et configuration de **GLPI** + **MySQL** hébergés sur un serveur Ubuntu AWS |
| **Émetteur**   | **Abdul-Bariu. Abdul-Majid. Aran**                                      |
| **Message**    | Présenter et documenter les résultats de notre installation              |
| **Récepteur**  | **M. Jérémy Massinon**                                                  |
| **Canal**      | Un dépôt GitLab                                                         |
| **Code**       | La langue française                                                     |
| **Référence**  | Consultez la [Documentation GLPI](https://faq.teclib.com/fr/03_knowledgebase/procedures/install_glpi/) |

---

## Préparation de l'environnement et prérequis

- Une VM Ubuntu Server pour l'installation des services.
- Une VM Ubuntu Client pour se connecter en SSH et exécuter les commandes.
- Accès root ou sudo pour les commandes d'installation.
- Connexion Internet active pour télécharger les paquets requis.

---

## 1. Installation et Configuration de MySQL (MariaDB)

### Installer `mariadb-server` et `mariadb-client`

```
sudo apt-get update
sudo apt-get install mariadb-server mariadb-client -y
```

### Créer la base de données pour GLPI

1. Se connecter à MariaDB en tant que root :

   ```
   sudo mysql -u root -p
   ```

2. Créer la base et l’utilisateur :

   ```
   CREATE DATABASE glpi CHARACTER SET UTF8 COLLATE UTF8_BIN;
   CREATE USER 'glpi'@'%' IDENTIFIED BY 'glpi';
   GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'%';
   FLUSH PRIVILEGES;
   ```

---

## 2. Installation des dépendances

### I. Installer Apache2

```
sudo apt-get install apache2 php libapache2-mod-php -y
```

### II. Installer PHP et les modules nécessaires

```
sudo apt-get install php-curl php-gd php-imagick php-intl php-apcu php-memcache php-imap php-mysql php-cas php-ldap php-tidy php-pear php-xmlrpc php-pspell php-mbstring php-json php-common php-bz2 php-xml php-gd php-zip -y
```
- Résultat de l'installation 

---
![Screenshot-2025-09-30-at-2-40-07-AM](https://i.postimg.cc/W4tCQM7f/Screenshot-2025-09-30-at-2-40-07-AM.png)
---

### III. Activer le module Rewrite pour Apache

```
sudo a2enmod rewrite
sudo systemctl restart apache2
```
- Résultat status apache = running
---
![Screenshot-2025-09-30-at-2-42-37-AM](https://i.postimg.cc/8C39Djy0/Screenshot-2025-09-30-at-2-42-37-AM.png)

---
### IV. Vérifier le statut d’Apache

```
sudo systemctl status apache2
```

---

## 3. Installation de GLPI

### I. Créer un dossier temporaire

```
mkdir ~/tmp
```

### II. Télécharger et extraire GLPI

```
cd /var/www/html
sudo wget https://github.com/glpi-project/glpi/releases/download/10.0.16/glpi-10.0.16.tgz
sudo tar -xvf glpi-10.0.16.tgz
sudo chown -R www-data:www-data glpi
```

### III. Activer la configuration GLPI et redémarrer Apache

```
sudo a2enconf glpi
sudo systemctl restart apache2
```

---

## 4. Configuration de GLPI via le navigateur

### I. Démarrage de l’installation

1. Ouvrir un navigateur et accéder à `http://<IP_SERVEUR>/glpi`
2. Sélectionner **Français** comme langue
3. Accepter la licence puis cliquer sur **Continuer**
4. Cliquer sur **Installer**
5. Vérifier que tous les prérequis sont au vert

### II. Configurer la connexion SQL

- **Serveur SQL** : `localhost`  
- **Utilisateur SQL** : `glpi`  
- **Mot de passe SQL** : `glpi`

### III. Sélection de la base

1. Choisir la base `glpi`
2. Suivre les étapes jusqu’à la fin
3. Cliquer sur **Utiliser GLPI**

### IV. Connexion à GLPI

- **Utilisateur** : `glpi`  
- **Mot de passe** : `glpi`

### V. Supprimer le script d’installation

```
sudo rm /var/www/html/glpi/install/install.php
```

---

## 5. Commandes de test (à exécuter sur la VM Ubuntu)

### Vérifier si MariaDB fonctionne

```
sudo systemctl status mariadb
```
- Résultat status mariadb = running
---
![Screenshot-2025-09-30-at-2-43-13-AM](https://i.postimg.cc/5tGT167V/Screenshot-2025-09-30-at-2-43-13-AM.png)

---
### Vérifier si Apache fonctionne

```
sudo systemctl status apache2
```

### Tester la connexion à la base GLPI

```
mysql -u glpi -pglpi -e "SHOW DATABASES;"
```

### Vérifier que le port 80 est bien ouvert

```
ss -tulpn | grep :80
```

### Vérifier que GLPI est accessible localement

```
http://localhost/glpi
```

### Vérifier la version de PHP

```
php -v
```

---

# Résumé

- **MariaDB** installé et base `glpi` créée.  
- **Apache2** et **PHP** configurés avec les bons modules.  
- **GLPI** téléchargé et installé sous `/var/www/html/glpi`.  
- Accès via navigateur : `http://<IP_SERVEUR>/glpi`.  
- Connexion avec identifiants par défaut : `glpi/glpi`.  
- Script d’installation supprimé pour sécuriser l’application.  
