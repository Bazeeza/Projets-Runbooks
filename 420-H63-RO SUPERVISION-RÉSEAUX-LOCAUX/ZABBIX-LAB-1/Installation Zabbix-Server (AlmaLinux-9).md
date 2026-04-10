# Guide d'Installation Zabbix - AlmaLinux 9

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


# Installation Zabbix - AlmaLinux 9
> Correction principale : **garantir que `DBPassword` est bien présent** dans `/etc/zabbix/zabbix_server.conf`.  
> Le problème rencontré venait d’une ligne `DBPassword` **absente** → Zabbix tentait la connexion **sans mot de passe** (`using password: NO`).

Environnement de référence :  
- Serveur AlmaLinux 9 : **192.168.2.175** (VM VMware, carte réseau Bridged)  
- Nom d’hôte : **srvlab-zabbix**  
- Base : **MariaDB**  
- Zabbix : **7.0 LTS**   
- Utilisateur/MDP DB : `zabbix` / `crosemont`

---

## Préparer l’OS (AlmaLinux 9)

- Vérifications que zabbix n'est pas installer
```
sudo systemctl status zabbix
```
- ou bien
- rpm -qa : liste tous les paquets installés.
- grep -i zabbix : filtre ceux qui contiennent “zabbix”
```
rpm -qa | grep -i zabbix || echo "OK: aucun paquet Zabbix installé"
```

- Pas totalement nécessaire
```
# Hostname + /etc/hosts (adapter l'IP à la tienne si besoin)
sudo hostnamectl set-hostname srvlab-zabbix
```
- Pas totalement nécessaire
```
echo -e "127.0.0.1   localhost\n192.168.2.175   srvlab-zabbix" | sudo tee -a /etc/hosts
```
- Update des mise à jours
```
# Mises à jour
sudo dnf -y update
```
- Pas nécessaire
```
# (si le noyau est mis à jour)
sudo reboot
```

---

## 1) Installer **MariaDB** (serveur + sécurisation)

```
sudo dnf -y install mariadb-server
sudo systemctl enable --now mariadb
sudo mysql_secure_installation
```

### Créer la **base** et l’**utilisateur** Zabbix (mot de passe `crosemont`)

```
sudo mysql -uroot
```

Dans le prompt `MariaDB>` :
```
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
DROP USER IF EXISTS 'zabbix'@'localhost';
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'crosemont';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Test rapide du compte DB
```
mysql -u zabbix -pcrosemont -e "SHOW DATABASES LIKE 'zabbix';"
```

---

## 2) Ajouter le **dépôt Zabbix 7.0 LTS** (Alma 9) + installer les paquets

```
# Dépôt officiel Zabbix 7.0 pour AlmaLinux 9
sudo rpm -Uvh https://repo.zabbix.com/zabbix/7.0/alma/9/x86_64/zabbix-release-latest-7.0.el9.noarch.rpm
sudo dnf clean all

# Paquets serveur + web (Apache/PHP-FPM) + scripts SQL + agent + SELinux policy
sudo dnf -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf \
                    zabbix-sql-scripts zabbix-agent zabbix-selinux-policy

# Outils utiles
sudo dnf -y install mariadb zabbix-get fping
```

### Timezone PHP du frontend (sinon l’assistant se plaint)
```
echo 'php_value[date.timezone] = America/Toronto' | sudo tee -a /etc/php-fpm.d/zabbix.conf
```

---

## 3) **Importer le schéma** SQL Zabbix dans la base

```
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | \
  mysql -u zabbix -pcrosemont zabbix
```

*(si besoin, en root)*
```
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | sudo mysql -uroot zabbix
```

---

## 4) Configurer **zabbix_server.conf** (accès DB) + démarrer services

> **Nouveauté (correction)** : on **applique** les 4 directives DB **et on les ajoute si elles n’existent pas**, pour éviter le cas “`using password: NO`”.

```
# Sauvegarde de la conf
sudo cp -a /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf.bak.$(date +%F-%H%M)

# 4.1 Décommenter/remplacer si les lignes existent déjà
sudo sed -i \
  -e 's/^[[:space:]]*#\?[[:space:]]*DBHost=.*/DBHost=localhost/' \
  -e 's/^[[:space:]]*#\?[[:space:]]*DBName=.*/DBName=zabbix/' \
  -e 's/^[[:space:]]*#\?[[:space:]]*DBUser=.*/DBUser=zabbix/' \
  -e 's/^[[:space:]]*#\?[[:space:]]*DBPassword=.*/DBPassword=crosemont/' \
  /etc/zabbix/zabbix_server.conf

# 4.2 Ajouter les clés manquantes à la fin du fichier (si elles n'existent pas)
sudo bash -c 'grep -q "^DBHost=" /etc/zabbix/zabbix_server.conf || echo "DBHost=localhost" >> /etc/zabbix/zabbix_server.conf'
sudo bash -c 'grep -q "^DBName=" /etc/zabbix/zabbix_server.conf || echo "DBName=zabbix"   >> /etc/zabbix/zabbix_server.conf'
sudo bash -c 'grep -q "^DBUser=" /etc/zabbix/zabbix_server.conf || echo "DBUser=zabbix"   >> /etc/zabbix/zabbix_server.conf'
sudo bash -c 'grep -q "^DBPassword=" /etc/zabbix/zabbix_server.conf || echo "DBPassword=crosemont" >> /etc/zabbix/zabbix_server.conf'

# 4.3 Vérifier ce que Zabbix va lire
sudo grep -nE '^(DBHost|DBName|DBUser|DBPassword)=' /etc/zabbix/zabbix_server.conf

# 4.4 Tester l'accès DB avec le compte applicatif
mysql -u zabbix -pcrosemont -e "SELECT 1;"
mysql -u zabbix -pcrosemont -e "USE zabbix; SHOW TABLES;" | wc -l   # > 100 attendu
```

### Démarrer/activer les services + firewall
```
sudo systemctl enable --now zabbix-server zabbix-agent httpd php-fpm

sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-port=10051/tcp --permanent   # zabbix-server
sudo firewall-cmd --add-port=10050/tcp --permanent   # zabbix-agent
sudo firewall-cmd --reload
```

### Vérifications web
```
# Apache & PHP-FPM actifs ?
sudo systemctl status httpd php-fpm --no-pager

# Port 80 écoute ?
sudo ss -lntp | grep ':80' || sudo netstat -lntp | grep ':80'

# Test local HTTP
curl -I http://127.0.0.1/zabbix
```

Depuis Windows/ton poste : **http://192.168.2.175/zabbix**  
Identifiants par défaut : **Admin / zabbix** (change le mot de passe ensuite).

---

## 5) (Rappel) Agent Zabbix Linux - conf minimale

```
sudo tee /etc/zabbix/zabbix_agentd.d/00-lab.conf >/dev/null <<'EOF'
Server=127.0.0.1,192.168.2.0/24
ServerActive=192.168.2.175
Hostname=srvlab-zabbix
EOF

sudo systemctl restart zabbix-agent
sudo ss -lntp | grep 10050 || sudo netstat -lntp | grep 10050

zabbix_get -s 127.0.0.1 -k agent.ping
zabbix_get -s 192.168.2.175 -k agent.ping
```

---

## 6) Dépannage express “Zabbix server is running: No”

```
sudo systemctl status zabbix-server --no-pager
sudo tail -n 50 /var/log/zabbix/zabbix_server.log   # chercher "using password: NO/YES"
sudo grep -nE '^(DBHost|DBName|DBUser|DBPassword)=' /etc/zabbix/zabbix_server.conf
mysql -u zabbix -pcrosemont -e "SELECT 1;"
```

**Cause typique** : `DBPassword` absent → **ajouter la ligne** (étape 4.2), redémarrer :  
```
sudo systemctl restart zabbix-server
```

---

**Conclusion** : cette version empêche le cas “`using password: NO`” en **ajoutant explicitement `DBPassword`** si la ligne n’existe pas dans le fichier de conf.


## 8) **Agent Windows 10/11**

### 8.1 Pare-feu Windows (ouvrir **10050/TCP**)
**PowerShell (Admin) :**
```
New-NetFirewallRule -DisplayName "Zabbix Agent 10050" -Direction Inbound -Protocol TCP -LocalPort 10050 -Action Allow
```

### 8.2 Installation silencieuse (Agent 2 MSI)
*(adapter le chemin vers le MSI téléchargé)*
```
msiexec /i "C:\Temp\zabbix_agent2-7.0.x-windows-amd64-openssl.msi" /qn ^
  SERVER=192.168.2.175 SERVERACTIVE=192.168.2.175 HOSTNAME=WIN11-LAB STARTUPTYPE=automatic
```

### 8.3 Vérifier/ajuster la config + redémarrer le service
```
Get-Service "Zabbix Agent 2"
Select-String -Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf" -Pattern '^(Server|ServerActive|Hostname)='
# Editer si besoin :
notepad "C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf"
Restart-Service "Zabbix Agent 2"

# Dernières lignes de log (debug)
Get-Content "C:\Program Files\Zabbix Agent 2\zabbix_agent2.log" -Tail 50
```

### 8.4 Tests depuis Alma vers l’agent Windows
```
# Remplacer <WIN_IP> par l'IP du PC Windows (ipconfig)
ping <WIN_IP> -c 3
zabbix_get -s <WIN_IP> -k agent.ping
zabbix_get -s <WIN_IP> -k system.hostname
```

*(Dans l’UI, créer l’hôte `WIN11-LAB`, interface Agent sur `<WIN_IP>:10050`, template **Windows by Zabbix agent**.)*

---

## 9) **Web Zabbix inaccessible** (dépannage express)

```
# Services web
sudo systemctl status httpd php-fpm --no-pager

# Port 80
sudo ss -lntp | grep ':80' || sudo netstat -lntp | grep ':80'

# Test local
curl -I http://127.0.0.1/zabbix

# Pare-feu Alma (HTTP)
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --reload

# SELinux (remettre les contextes web si besoin)
sudo dnf -y install policycoreutils-python-utils
sudo restorecon -Rv /usr/share/zabbix
```

---

## 10) **Reset mot de passe Admin** (si oublié/bloqué)

```
sudo mysql -uroot
```

Dans `MariaDB>` :
```
USE zabbix;

-- Remet "Admin" -> mot de passe "zabbix" (hash officiel) et débloque le compte
UPDATE users
SET passwd = '$2a$10$ZXIvHAEP2ZM.dLXTm6uPHOMVlARXX7cqjbhM6Fn0cANzkCQBWpMrS',
    attempt_failed = 0
WHERE username = 'Admin';

FLUSH PRIVILEGES;
EXIT;
```

---

## 11) **Commandes de vérification finales**

```
# Services Zabbix/appli web
sudo systemctl status zabbix-server zabbix-agent httpd php-fpm --no-pager

# Agent Linux (local)
zabbix_get -s 127.0.0.1 -k agent.ping
zabbix_get -s 192.168.2.175 -k system.hostname

# Connectivité vers Windows
zabbix_get -s <WIN_IP> -k agent.ping
zabbix_get -s <WIN_IP> -k system.hostname
```

---