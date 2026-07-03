# MeshCentral - Guide d'Installation
**Procédurier 18 Étapes - Ubuntu 24.04 LTS**

| Élément       | Contenu                                                                                         |
|---------------|-------------------------------------------------------------------------------------------------|
| **Référent**  | Installation complète d'un serveur MeshCentral auto-hébergé sur VPS Ubuntu, avec MongoDB 8.0, certificat TLS via acme.sh, thème graphique Stylish UI, sauvegardes automatiques et connexion d'appareils Windows et macOS. |
| **Émetteur**  | Communauté open source - guide contributif public                                               |
| **Message**   | Fournir un procédurier complet, corrigé et validé, permettant à tout utilisateur de déployer MeshCentral en production sur Ubuntu 24.04. |
| **Récepteur** | Administrateurs systèmes, entreprises et utilisateurs privés souhaitant héberger leur propre serveur de gestion à distance. |
| **Canal**     | Dépôt GitHub public                                                                             |
| **Code**      | La langue française                                                                             |
| **Référence** | Consultez la [Documentation officielle MeshCentral](https://docs.meshcentral.com), [acme.sh](https://github.com/acmesh-official/acme.sh) et [DuckDNS](https://www.duckdns.org). |

---

## Système testé

| Composant     | Version                  |
|---------------|--------------------------|
| OS            | Ubuntu 24.04.3 LTS Noble |
| MeshCentral   | v1.2.1                   |
| Node.js       | v20.20.2 LTS             |
| MongoDB       | 8.0                      |

---

## Table des matières

1. [Avant de commencer](#1--avant-de-commencer)
2. [Mise à jour du système](#2--mise-à-jour-du-système)
3. [Sécurisation SSH](#3--sécurisation-ssh)
4. [Pare-feu UFW](#4--pare-feu-ufw)
5. [Protection fail2ban](#5--protection-fail2ban)
6. [Node.js 20 LTS](#6--nodejs-20-lts)
7. [MongoDB 8.0](#7--mongodb-80)
8. [Dossier isolé et utilisateur de service](#8--dossier-isolé-et-utilisateur-de-service)
9. [Installation de MeshCentral](#9--installation-de-meshcentral)
10. [Configuration config.json](#10--configuration-configjson)
11. [Thème graphique moderne](#11--thème-graphique-moderne)
12. [Service systemd](#12--service-systemd)
13. [Domaine gratuit DuckDNS](#13--domaine-gratuit-duckdns)
14. [Certificat TLS avec acme.sh](#14--certificat-tls-avec-acmesh)
15. [Démarrage et vérification](#15--démarrage-et-vérification)
16. [Sauvegardes automatiques](#16--sauvegardes-automatiques)
17. [Premier login et sécurisation](#17--premier-login-et-sécurisation)
18. [Connexion des appareils](#18--connexion-des-appareils)
19. [Dépannage](#19--dépannage)
20. [Maintenance](#20--maintenance)

---

## Conventions de ce guide

- Copiez-collez **une commande à la fois**.
- Chaque étape contient une commande de vérification et le résultat attendu.
- Ne passez pas à l'étape suivante si la vérification échoue.
- Les textes entre `< >` sont des valeurs à remplacer par les vôtres.

---

## 1 - Avant de commencer

### 1.1 - Prérequis serveur

| Ressource | Minimum   | Recommandé |
|-----------|-----------|------------|
| OS        | Ubuntu 22.04 LTS | Ubuntu 24.04 LTS |
| RAM       | 2 GB      | 4 GB       |
| Disque    | 20 GB     | 40 GB      |
| CPU       | 1 vCPU    | 2 vCPU     |

### 1.2 - Passer en root pour toute la session d'installation

> Note importante : Ne pas utiliser `sudo commande > fichier` - la redirection échoue
> car le shell exécute la redirection en tant qu'utilisateur normal, pas root.
> Passez en root une seule fois avec `sudo -i` pour toute la durée de l'installation.

```bash
sudo -i
```

Vérifier :
```bash
whoami
```
Attendu : `root`

### 1.3 - Vérifier les ressources disponibles

```bash
lsb_release -a
```
Attendu : Ubuntu 22.04 ou 24.04

```bash
free -h
```
Attendu : Au moins 2 GB sous `Mem:`

```bash
df -h /
```
Attendu : Au moins 15 GB libres sous `Avail`

### 1.4 - Trouver l'IP publique du serveur

```bash
curl -4 https://api.ipify.org && echo
```

Notez cette IP - vous en aurez besoin pour configurer le DNS.

---

## 2 - Mise à jour du système

### 2.1 - Mettre à jour les paquets

```bash
apt update && apt -y upgrade
```

### 2.2 - Installer les outils essentiels

```bash
apt -y install curl wget gnupg ca-certificates \
  jq dnsutils ufw fail2ban unattended-upgrades \
  build-essential git openssl net-tools
```

Vérifier que tout est installé :
```bash
for cmd in curl wget jq dig ufw openssl; do
  printf "%-20s %s\n" "$cmd" "$(command -v $cmd || echo 'NON TROUVE')"
done
```
Attendu : Un chemin pour chaque outil, aucun `NON TROUVE`.

### 2.3 - Activer les mises à jour de sécurité automatiques

```
echo 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";' > /etc/apt/apt.conf.d/20auto-upgrades
```

Vérifier :
```
cat /etc/apt/apt.conf.d/20auto-upgrades
```
Attendu :
```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
```

### 2.4 - Ajouter 2 GB de swap

> Recommandé si votre VPS n'a pas de swap configuré. Vérifiez d'abord :
> `free -h | grep Swap` - si la ligne affiche `0B`, ajoutez le swap ci-dessous.

```
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

Vérifier :
```
free -h | grep Swap
```
Attendu : `Swap: 2.0G`

---

## 3 - Sécurisation SSH

### 3.1 - Vérifier si une clé SSH est configurée

```
cat ~/.ssh/authorized_keys 2>/dev/null || echo "AUCUNE CLE TROUVEE"
```

- Si une clé s'affiche (longue ligne commençant par `ssh-rsa` ou `ssh-ed25519`) : suivez les étapes 3.2 et 3.3.
- Si `AUCUNE CLE TROUVEE` : suivez seulement l'étape 3.2 et sautez l'étape 3.3 pour éviter de vous verrouiller.

### 3.2 - Désactiver la connexion root via SSH

```
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
grep -qE '^\s*PermitRootLogin' /etc/ssh/sshd_config || echo "PermitRootLogin no" >> /etc/ssh/sshd_config
```

Vérifier :
```
grep "PermitRootLogin" /etc/ssh/sshd_config
```
Attendu : `PermitRootLogin no`

### 3.3 - Désactiver le login par mot de passe (seulement si une clé SSH est présente)

```
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
grep -qE '^\s*PasswordAuthentication' /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
```

Vérifier :
```
grep "PasswordAuthentication" /etc/ssh/sshd_config
```
Attendu : `PasswordAuthentication no`

### 3.4 - Redémarrer SSH

```bash
systemctl restart ssh
```

Vérifier :
```bash
systemctl status ssh | grep "Active:"
```
Attendu : `Active: active (running)`

> Ouvrez un second terminal et confirmez que vous pouvez toujours vous connecter avant de continuer.

---

## 4 - Pare-feu UFW

> UFW ajoute des règles de manière additive. Vos règles existantes pour d'autres services
> ne seront pas supprimées.

### 4.1 - Configurer les politiques et les ports

```bash
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 4433/tcp
ufw --force enable
```

> Note : Le port 4433 est obligatoire pour le bureau distant (VNC et RDP relay).
> Sans ce port, la connexion au bureau des appareils distants échoue silencieusement.

Vérifier :
```bash
ufw status numbered
```
Attendu :
```
Status: active
[ 1] OpenSSH    ALLOW IN
[ 2] 80/tcp     ALLOW IN
[ 3] 443/tcp    ALLOW IN
[ 4] 4433/tcp   ALLOW IN
```

---

## 5 - Protection fail2ban

### 5.1 - Créer la configuration

```bash
tee /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime  = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
EOF
```

### 5.2 - Activer et démarrer

```bash
systemctl enable fail2ban
systemctl restart fail2ban
```

Vérifier :
```bash
systemctl status fail2ban | grep "Active:"
```
Attendu : `Active: active (running)`

```bash
fail2ban-client status
```
Attendu : Affiche `sshd` dans la liste des jails actifs.

---

## 6 - Node.js 20 LTS

### 6.1 - Ajouter le dépôt NodeSource

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
```

Attendu : Se termine par `Now run: apt-get install -y nodejs`

### 6.2 - Installer Node.js

```bash
apt -y install nodejs
```

Vérifier :
```bash
node -v
```
Attendu : `v20.x.x`

```bash
npm -v
```
Attendu : `10.x.x` ou supérieur

---

## 7 - MongoDB 8.0

> Correction importante : MongoDB 7.0 n'est pas compatible avec Ubuntu 24.04 Noble.
> Utilisez obligatoirement MongoDB 8.0 sur Ubuntu 24.04. MongoDB 7.0 retourne une
> erreur 404 lors de l'installation sur Noble.

### 7.1 - Importer la clé GPG MongoDB

```bash
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
  gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor --yes
```

Vérifier :
```bash
ls -la /usr/share/keyrings/mongodb-server-8.0.gpg
```
Attendu : Fichier présent avec une taille supérieure à 0.

### 7.2 - Ajouter le dépôt MongoDB

Pour Ubuntu 24.04 (Noble) :
```bash
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" \
  | tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

Pour Ubuntu 22.04 (Jammy) :
```bash
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" \
  | tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

> Pour connaître votre version Ubuntu : `lsb_release -cs` retourne `noble` ou `jammy`.

### 7.3 - Installer MongoDB

```bash
apt update && apt -y install mongodb-org
```

Vérifier la version :
```bash
mongod --version
```
Attendu : `db version v8.0.x`

### 7.4 - Verrouiller MongoDB sur localhost uniquement

```bash
sed -i 's/^\(\s*bindIp:\).*/\1 127.0.0.1/' /etc/mongod.conf
```

Vérifier :
```bash
grep "bindIp" /etc/mongod.conf
```
Attendu : `  bindIp: 127.0.0.1`

### 7.5 - Activer et démarrer

```bash
systemctl enable mongod
systemctl start mongod
sleep 3 && systemctl status mongod | grep "Active:"
```
Attendu : `Active: active (running)`

### 7.6 - Vérifications de sécurité

```bash
ss -tlnp | grep 27017
```
Attendu : `127.0.0.1:27017` uniquement. Ne doit jamais afficher `0.0.0.0:27017`.

```bash
mongosh --quiet --eval "db.adminCommand({ ping: 1 })"
```
Attendu : `{ ok: 1 }`

---

## 8 - Dossier isolé et utilisateur de service

MeshCentral est installé dans son propre dossier, complètement séparé de vos autres services.

### 8.1 - Créer l'utilisateur de service dédié

```bash
useradd -r -m -d /opt/meshcentral-server -s /usr/sbin/nologin meshcentral
```

Vérifier :
```bash
id meshcentral
```
Attendu : `uid=... gid=... groups=...`

### 8.2 - Créer la structure de dossiers

```bash
install -d -o meshcentral -g meshcentral -m 750 \
  /opt/meshcentral-server \
  /opt/meshcentral-server/meshcentral-data \
  /opt/meshcentral-server/meshcentral-files \
  /opt/meshcentral-server/meshcentral-backups \
  /opt/meshcentral-server/meshcentral-web \
  /opt/meshcentral-server/meshcentral-web/public \
  /opt/meshcentral-server/meshcentral-web/public/styles \
  /opt/meshcentral-server/meshcentral-web/public/scripts \
  /opt/meshcentral-server/meshcentral-web/public/images
```

Vérifier :
```bash
ls -la /opt/meshcentral-server/
```
Attendu : Tous les sous-dossiers présents, propriétaire `meshcentral`.

### 8.3 - Autoriser Node.js à utiliser les ports inférieurs à 1024 sans root

```bash
setcap 'cap_net_bind_service=+ep' $(readlink -f $(which node))
```

Vérifier :
```bash
getcap $(readlink -f $(which node))
```
Attendu : `...node = cap_net_bind_service+ep`

---

## 9 - Installation de MeshCentral

```bash
su -s /bin/bash -c \
  "cd /opt/meshcentral-server && npm install meshcentral --no-fund --no-audit" \
  meshcentral
```

> Cette commande prend 2 à 4 minutes. Les avertissements `deprecated` et
> `npm update available` sont normaux et peuvent être ignorés.

Vérifier que le module est installé :
```bash
ls /opt/meshcentral-server/node_modules/meshcentral/package.json
```
Attendu : Le fichier existe sans erreur.

Vérifier la version installée :
```bash
node -e "console.log(require('/opt/meshcentral-server/node_modules/meshcentral/package.json').version)"
```
Attendu : Un numéro de version comme `1.2.x`

---

## 10 - Configuration config.json

> Remplacez `VOTRE_DOMAINE.duckdns.org` et `votre@email.com` avant de coller.
> Adaptez également `title`, `title2`, `companyName` et `serviceName` à votre contexte.

```bash
tee /opt/meshcentral-server/meshcentral-data/config.json << 'EOF'
{
  "$schema": "https://raw.githubusercontent.com/Ylianst/MeshCentral/master/meshcentral-config-schema.json",

  "settings": {
    "cert": "VOTRE_DOMAINE.duckdns.org",
    "MongoDb": "mongodb://127.0.0.1:27017/meshcentral",
    "MongoDbName": "meshcentral",
    "Port": 443,
    "AliasPort": 443,
    "RedirPort": 80,
    "RedirAliasPort": 80,
    "TlsOffload": false,
    "SelfUpdate": false,
    "AgentPong": 300,
    "MaxInvalidLogin": { "time": 10, "count": 5, "coolofftime": 30 },
    "AllowHighQualityDesktop": true
  },

  "domains": {
    "": {
      "title": "Mon Serveur",
      "title2": "Remote Command Center",
      "nightMode": 1,
      "siteStyle": 3,
      "minify": true,
      "newAccounts": true,
      "userNameIsEmail": true,
      "geoLocation": false,
      "welcomeText": "Acces autorise uniquement.",
      "hstsHeader": true,

      "passwordRequirements": {
        "min": 12,
        "max": 128,
        "upper": 1,
        "lower": 1,
        "numeric": 1,
        "nonalpha": 1,
        "lockoutMinutes": 30,
        "banUserCount": 5
      },

      "agentInviteCodes": true,
      "limitedEvents": true,

      "userConsentFlags": {
        "desktopnotify": true,
        "terminalnotify": true,
        "filenotify": true
      },

      "sessionRecording": {
        "onlyServer": true,
        "filter": [1, 2]
      },

      "agentCustomization": {
        "displayName": "Mon Agent",
        "description": "Service de gestion a distance",
        "companyName": "Mon Entreprise",
        "serviceName": "MonAgent"
      }
    }
  }
}
EOF
```

Appliquer les permissions :
```bash
chown meshcentral:meshcentral /opt/meshcentral-server/meshcentral-data/config.json
chmod 600 /opt/meshcentral-server/meshcentral-data/config.json
```

Vérifier les permissions :
```bash
ls -la /opt/meshcentral-server/meshcentral-data/config.json
```
Attendu : `-rw------- 1 meshcentral meshcentral`

Valider le JSON :
```bash
jq empty /opt/meshcentral-server/meshcentral-data/config.json && echo "JSON VALIDE"
```
Attendu : `JSON VALIDE`

---

## 11 - Thème graphique moderne

Ce guide utilise le thème Stylish UI, développé par la communauté MeshCentral.
Il modernise complètement l'interface avec un design Bootstrap responsive.

### 11.1 - Télécharger Stylish UI

```bash
curl -fsSL \
  "https://raw.githubusercontent.com/Melo-Professional/MeshCentral-Stylish-UI/main/meshcentral-web/public/styles/custom.css" \
  -o /opt/meshcentral-server/meshcentral-web/public/styles/custom.css
```

```bash
curl -fsSL \
  "https://raw.githubusercontent.com/Melo-Professional/MeshCentral-Stylish-UI/main/meshcentral-web/public/scripts/custom.js" \
  -o /opt/meshcentral-server/meshcentral-web/public/scripts/custom.js
```

Vérifier :
```bash
wc -l /opt/meshcentral-server/meshcentral-web/public/styles/custom.css
```
Attendu : Plus de 100 lignes.

### 11.2 - Créer un logo SVG

```bash
python3 << 'EOF'
svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 450 66" width="450" height="66">
  <defs>
    <linearGradient id="g1" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#00d4ff"/>
      <stop offset="100%" style="stop-color:#7b2fff"/>
    </linearGradient>
  </defs>
  <rect width="450" height="66" fill="#0a0f1e"/>
  <circle cx="28" cy="33" r="9" fill="url(#g1)"/>
  <circle cx="54" cy="16" r="5" fill="#00d4ff" opacity="0.85"/>
  <circle cx="54" cy="50" r="5" fill="#7b2fff" opacity="0.85"/>
  <circle cx="76" cy="33" r="4" fill="#00d4ff" opacity="0.6"/>
  <line x1="28" y1="24" x2="51" y2="18" stroke="url(#g1)" stroke-width="1.5"/>
  <line x1="28" y1="42" x2="51" y2="48" stroke="url(#g1)" stroke-width="1.5"/>
  <line x1="54" y1="21" x2="54" y2="45" stroke="#4a9eff" stroke-width="1" opacity="0.5"/>
  <text x="96" y="40" font-family="Arial Black, Arial, sans-serif" font-weight="900" font-size="28" fill="#ffffff">MON</text>
  <text x="160" y="40" font-family="Arial Black, Arial, sans-serif" font-weight="900" font-size="28" fill="url(#g1)">NET</text>
  <text x="97" y="54" font-family="Arial, sans-serif" font-size="9" fill="#4a9eff" letter-spacing="4">REMOTE COMMAND CENTER</text>
</svg>'''
with open('/opt/meshcentral-server/meshcentral-web/public/images/logo.svg', 'w') as f:
    f.write(svg)
print("Logo SVG cree")
EOF
```

### 11.3 - Corriger les permissions

```bash
chown -R meshcentral:meshcentral /opt/meshcentral-server/meshcentral-web
```

---

## 12 - Service systemd

### 12.1 - Créer le fichier de service

```bash
tee /etc/systemd/system/meshcentral.service << 'EOF'
[Unit]
Description=MeshCentral Remote Management Server
After=network.target mongod.service
Wants=mongod.service

[Service]
Type=simple
User=meshcentral
Group=meshcentral
WorkingDirectory=/opt/meshcentral-server
ExecStart=/usr/bin/node /opt/meshcentral-server/node_modules/meshcentral
Restart=always
RestartSec=5
NoNewPrivileges=true
ProtectSystem=full
ProtectHome=true
PrivateTmp=true
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF
```

### 12.2 - Activer le service

```bash
systemctl daemon-reload
systemctl enable meshcentral
```

Vérifier :
```bash
systemctl is-enabled meshcentral
```
Attendu : `enabled`

---

## 13 - Domaine gratuit DuckDNS

DuckDNS offre des sous-domaines gratuits compatibles avec Let's Encrypt.

### 13.1 - Créer votre sous-domaine

1. Rendez-vous sur https://www.duckdns.org
2. Connectez-vous avec Google ou GitHub
3. Entrez un nom de sous-domaine (ex: `monserveur`) et cliquez **add domain**
4. Entrez l'IP publique de votre VPS dans le champ IP et cliquez **update ip**

Votre domaine sera : `monserveur.duckdns.org`

Notez votre token DuckDNS - visible en haut de la page après connexion.

> Securite : Ne partagez jamais votre token DuckDNS publiquement. Il permet le controle
> total de votre domaine. Si votre token est compromis, regenerez-en un nouveau
> immediatement depuis l'interface DuckDNS.

### 13.2 - Vérifier la propagation DNS

```bash
dig +short VOTRE_DOMAINE.duckdns.org
```
Attendu : L'IP publique de votre VPS. Si rien ne s'affiche, attendez 5 minutes.

---

## 14 - Certificat TLS avec acme.sh

> Correction importante : Deux méthodes ont été testées et échouent avec DuckDNS :
>
> 1. Le plugin `certbot-dns-duckdns` insère incorrectement le record TXT.
> 2. La méthode standalone certbot échoue si Let's Encrypt ne peut pas résoudre le domaine.
>
> La solution fiable et validée est acme.sh avec le module natif dns_duckdns.

### 14.1 - Installer acme.sh

```bash
curl https://get.acme.sh | sh -s email=votre@email.com
source ~/.bashrc
```

Attendu : `Install success!`

### 14.2 - Définir le token DuckDNS

```bash
export DuckDNS_Token="VOTRE_TOKEN_DUCKDNS"
```

### 14.3 - Obtenir le certificat

```bash
~/.acme.sh/acme.sh --issue --dns dns_duckdns \
  -d VOTRE_DOMAINE.duckdns.org \
  --dnssleep 120
```

> Cette commande attend 2 minutes pour la propagation DNS avant la validation.
> C'est normal. La commande complète prend environ 3 minutes.

Attendu en fin de commande :
```
Cert success.
Your cert is in: /root/.acme.sh/VOTRE_DOMAINE.duckdns.org_ecc/VOTRE_DOMAINE.duckdns.org.cer
```

### 14.4 - Installer le certificat vers MeshCentral

```bash
~/.acme.sh/acme.sh --install-cert -d VOTRE_DOMAINE.duckdns.org \
  --key-file /opt/meshcentral-server/meshcentral-data/webserver-cert-private.key \
  --fullchain-file /opt/meshcentral-server/meshcentral-data/webserver-cert-public.crt \
  --reloadcmd "chown meshcentral:meshcentral \
    /opt/meshcentral-server/meshcentral-data/webserver-cert-private.key \
    /opt/meshcentral-server/meshcentral-data/webserver-cert-public.crt && \
    systemctl restart meshcentral"
```

Attendu : `Reload successful`

> acme.sh configure automatiquement une tâche cron pour renouveler le certificat
> tous les 60 jours. Aucune action manuelle n'est nécessaire.

---

## 15 - Démarrage et vérification

### 15.1 - Démarrer MeshCentral

```bash
systemctl start meshcentral
```

### 15.2 - Surveiller les logs au démarrage

```bash
journalctl -u meshcentral -f
```

Attendez ces messages :
```
MeshCentral HTTP redirection server running on port 80.
MeshCentral HTTPS server running on VOTRE_DOMAINE.duckdns.org:443, alias port 443.
```

Appuyez sur Ctrl+C pour arrêter l'affichage des logs.

### 15.3 - Vérification complète en une commande

```bash
echo "=== MESHCENTRAL HEALTH CHECK ===" && \
echo "Service   : $(systemctl is-active meshcentral)" && \
echo "Enabled   : $(systemctl is-enabled meshcentral)" && \
echo "MongoDB   : $(systemctl is-active mongod)" && \
echo "Firewall  : $(ufw status | grep 'Status' | awk '{print $2}')" && \
echo "Node      : $(node -v)" && \
echo "Process   : $(ps -o user= -C node 2>/dev/null | head -1)" && \
echo "================================="
```

Attendu : `active`, `enabled`, `active`, `active`, `v20.x.x`, `meshcentral`

> Le processus doit tourner en tant que `meshcentral` - jamais `root`.

### 15.4 - Vérifier le certificat TLS

```bash
echo | openssl s_client -connect VOTRE_DOMAINE.duckdns.org:443 \
  -servername VOTRE_DOMAINE.duckdns.org 2>/dev/null \
  | openssl x509 -noout -issuer -dates
```

Attendu : `issuer=...ZeroSSL...` ou `...Let's Encrypt...` avec des dates valides dans les 90 prochains jours.

### 15.5 - Vérifier la redirection HTTP vers HTTPS

```bash
curl -I http://VOTRE_DOMAINE.duckdns.org 2>/dev/null | grep -E "HTTP|Location"
```

Attendu :
```
HTTP/1.1 302 Found
Location: https://VOTRE_DOMAINE.duckdns.org/
```

---

## 16 - Sauvegardes automatiques

### 16.1 - Créer le dossier de sauvegarde

```bash
mkdir -p /var/backups/meshcentral
chmod 700 /var/backups/meshcentral
```

### 16.2 - Créer le script de sauvegarde

```bash
tee /opt/meshcentral-server/backup.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
TS=$(date +%F_%H%M)
DEST="/var/backups/meshcentral/$TS"
mkdir -p "$DEST"

# Base de données MongoDB
mongodump \
  --uri="mongodb://127.0.0.1:27017/meshcentral" \
  --archive="$DEST/database.archive" \
  --gzip

# Configuration, certificats et cles de signature des agents
# Ce dossier est critique : sa perte oblige la reinstallation de tous les agents
tar czf "$DEST/meshcentral-data.tar.gz" \
  -C /opt/meshcentral-server \
  meshcentral-data

# Supprimer les sauvegardes de plus de 14 jours
find /var/backups/meshcentral \
  -maxdepth 1 -type d -mtime +14 -exec rm -rf {} + 2>/dev/null || true

echo "Sauvegarde terminee : $DEST"
EOF
```

```bash
chmod 700 /opt/meshcentral-server/backup.sh
```

### 16.3 - Tester la sauvegarde immédiatement

```bash
/opt/meshcentral-server/backup.sh
```

Attendu : `Sauvegarde terminee : /var/backups/meshcentral/YYYY-MM-DD_HH:MM`

Vérifier les fichiers créés :
```bash
ls -lh /var/backups/meshcentral/$(ls /var/backups/meshcentral | tail -1)/
```

Attendu : Deux fichiers (`database.archive` et `meshcentral-data.tar.gz`) avec une taille supérieure à 0.

### 16.4 - Planifier les sauvegardes nocturnes

```bash
echo "30 2 * * * root /opt/meshcentral-server/backup.sh >> /var/log/meshcentral-backup.log 2>&1" \
  | tee /etc/cron.d/meshcentral-backup
```

> Rappel de sécurité : Une sauvegarde stockée uniquement sur le même serveur ne protège
> pas contre une perte complète du VPS. Copiez régulièrement les sauvegardes vers un
> stockage externe (Backblaze B2, Amazon S3, autre serveur).

---

## 17 - Premier login et sécurisation

### 17.1 - Accéder à la console

Ouvrez dans votre navigateur :
```
https://VOTRE_DOMAINE.duckdns.org
```

Vous devez voir la page de login avec le thème sombre Stylish UI.

### 17.2 - Créer le compte administrateur

- Cliquez **Create Account**
- Le premier compte créé devient automatiquement administrateur du site
- Utilisez votre adresse email comme identifiant
- Choisissez un mot de passe d'au moins 12 caractères avec majuscule, minuscule, chiffre et symbole

### 17.3 - Activer le 2FA (recommandé)

1. Cliquez votre nom en haut à droite → **My Account** → **Security**
2. **Two-factor authentication** → **Add** → **Authenticator App**
3. Scannez le QR code avec une application d'authentification (Google Authenticator, Authy, 1Password)
4. Entrez le code à 6 chiffres pour confirmer

### 17.4 - Fermer les inscriptions

> Cette étape est critique. Fermez les inscriptions immédiatement après avoir créé
> votre compte administrateur pour empêcher tout accès non autorisé.

```bash
python3 << 'EOF'
import json
path = '/opt/meshcentral-server/meshcentral-data/config.json'
with open(path) as f:
    cfg = json.load(f)
cfg['domains']['']['newAccounts'] = False
with open(path, 'w') as f:
    json.dump(cfg, f, indent=2)
print("Inscriptions fermees - newAccounts: false")
EOF
```

```bash
systemctl restart meshcentral
```

Vérifier :
```bash
jq '.domains[""].newAccounts' /opt/meshcentral-server/meshcentral-data/config.json
```
Attendu : `false`

---

## 18 - Connexion des appareils

### 18.1 - Créer un groupe d'appareils dans la console

1. Dans la barre de gauche → **Add Device Group**
2. Nom : `Mes Ordinateurs` (ou selon votre contexte)
3. Type : **Manage with software agents** - ce choix est obligatoire pour les agents logiciels
4. Cliquez **OK**

### 18.2 - Agent Windows

**Générer l'installeur :**
1. Cliquez le groupe → **Add Agent** → **Windows**
2. Téléchargez le fichier `.exe`

**Installer sur le PC Windows :**
- Clic droit sur le fichier → **Exécuter en tant qu'administrateur**

> Correction importante : L'agent Windows doit impérativement être installé en tant
> qu'administrateur pour s'enregistrer comme service SYSTEM. Si l'agent est lancé sans
> droits administrateur, il tourne sous le compte utilisateur et ne peut pas capturer
> le bureau pour le VNC ou le RDP relay. L'appareil apparaît connecté mais le bureau
> distant échoue.

Vérifier que l'agent tourne en SYSTEM (PowerShell sur le PC Windows) :
```powershell
Get-WmiObject Win32_Process -Filter "name='meshagent.exe'" | Select-Object ProcessId, @{n='User';e={$_.GetOwner().User}}
```
Attendu : `User : SYSTEM`

### 18.3 - Activer RDP sur Windows pour Web-RDP

Sur le PC Windows, ouvrir PowerShell en tant qu'administrateur :

```powershell
# Activer RDP
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0

# Ouvrir le pare-feu Windows pour RDP
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Desactiver NLA (requis pour la compatibilite avec le Web-RDP de MeshCentral)
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication -Value 0

# Autoriser l'utilisateur a se connecter en RDP
net localgroup "Remote Desktop Users" "NOM_UTILISATEUR_WINDOWS" /add
```

Trouver votre nom d'utilisateur Windows exact :
```powershell
whoami
```
Le résultat est `nomordinateur\nomutilisateur`. Utilisez uniquement la partie après le `\`.

Connexion dans MeshCentral Web-RDP :

| Champ       | Valeur                                  |
|-------------|-----------------------------------------|
| Domaine     | Laisser vide pour un PC personnel       |
| Utilisateur | Votre nom d'utilisateur Windows         |
| Mot de passe| Votre mot de passe de compte Windows    |

> Notes importantes pour RDP :
> - Le PIN Windows n'est pas accepté par RDP. Vous devez avoir un mot de passe de compte configuré.
> - RDP fonctionne uniquement sur Windows Pro, Education et Enterprise. Windows Home ne supporte pas RDP.
> - Si la connexion affiche un écran blanc puis retourne à la page de login, désactivez NLA avec la commande ci-dessus.

### 18.4 - Agent macOS

**Télécharger et installer :**
1. Cliquez le groupe → **Add Agent** → **macOS** → **Universal**
   (Universal fonctionne sur tous les Mac : Intel, M1, M2, M3)
2. Clic droit sur le `.pkg` → **Ouvrir** (pour contourner Gatekeeper)
3. Suivez l'assistant d'installation

**Permissions obligatoires :**

Les permissions suivantes doivent être accordées manuellement sur macOS.
Sur macOS 15 Sequoia, la base de données TCC est en lecture seule même avec sudo
en raison de SIP. Les permissions doivent être accordées via les Réglages Système.

1. **System Settings → Privacy and Security → Screen Recording**
   Trouvez l'agent dans la liste et activez le bouton.

2. **System Settings → Privacy and Security → Accessibility**
   Trouvez l'agent dans la liste et activez le bouton.

3. Redémarrez le Mac complètement.

> Sans ces deux permissions, l'agent apparaît connecté dans la console mais le bureau
> distant retourne une erreur de connexion.

### 18.5 - Mode plein écran pour le bureau distant

Pour obtenir un affichage agrandi du bureau distant :

Méthode 1 - Fenêtre détachée :
1. Cliquez votre appareil → onglet **Desktop**
2. Dans la barre d'outils, cliquez l'icône de détachement (carré avec flèche vers l'extérieur)
3. Le bureau s'ouvre dans une nouvelle fenêtre indépendante
4. Appuyez sur **F11** pour le plein écran navigateur

Méthode 2 - Shift+Clic :
- Maintenez **Shift** et cliquez le bouton fullscreen dans la barre d'outils
- Le bureau s'ouvre directement en popup séparé

---

## 19 - Dépannage

### Tableau des problèmes courants

| Symptôme | Cause probable | Solution |
|---|---|---|
| Page ne charge pas | DNS pas encore propagé | `dig +short VOTRE_DOMAINE.duckdns.org` et attendre |
| Certificat invalide ou auto-signe | acme.sh n'a pas encore été exécuté | Relancer l'étape 14.3 |
| Bureau distant échoue | Port 4433 non ouvert | `ufw allow 4433/tcp` |
| VNC ou RDP blanc | Agent Windows pas en SYSTEM | Réinstaller le `.exe` en tant qu'administrateur |
| macOS bureau ne fonctionne pas | Permission Screen Recording manquante | Accorder manuellement dans Réglages Système |
| Permission denied avec `>` | Redirection shell sans élévation | Utiliser `tee` : `echo "texte" \| tee /fichier` |
| DNS ne résout pas depuis le serveur | systemd-resolved ecrase | Voir la section Correction DNS ci-dessous |
| MongoDB ne démarre pas | bindIp mal configuré | Vérifier `/etc/mongod.conf` ligne `bindIp` |
| RDP écran blanc | NLA activé | Désactiver NLA (étape 18.3) |

### Correction DNS systemd-resolved (Ubuntu 24.04)

> Ne jamais écrire directement dans `/etc/resolv.conf` sur Ubuntu 24.04.
> Ce fichier est un lien symbolique géré par systemd-resolved.
> L'écraser directement casse la résolution DNS de tout le système.

Configurer des serveurs DNS permanents via systemd-resolved :
```bash
mkdir -p /etc/systemd/resolved.conf.d/
tee /etc/systemd/resolved.conf.d/dns.conf << 'EOF'
[Resolve]
DNS=8.8.8.8 8.8.4.4
FallbackDNS=1.1.1.1
EOF
systemctl restart systemd-resolved
```

Restaurer le lien symbolique s'il a été écrasé :
```bash
rm /etc/resolv.conf
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
systemctl restart systemd-resolved
```

Vérifier que la résolution fonctionne :
```bash
dig +short VOTRE_DOMAINE.duckdns.org
```

### Commandes de diagnostic

```bash
# Logs MeshCentral en direct
journalctl -u meshcentral -f

# 50 dernieres lignes de log
journalctl -u meshcentral -n 50 --no-pager

# Filtrer les erreurs et avertissements
journalctl -u meshcentral -n 100 --no-pager | grep -i "error\|warn\|fail"

# Statut de tous les services
systemctl status meshcentral mongod fail2ban

# Ports en ecoute
ss -tlnp | grep -E ':80|:443|:4433|:27017'

# Logs MongoDB
journalctl -u mongod -n 30 --no-pager
```

---

## 20 - Maintenance

### Mise à jour de MeshCentral

```bash
# Etape 1 : sauvegarder avant toute mise a jour
/opt/meshcentral-server/backup.sh

# Etape 2 : arreter le service
systemctl stop meshcentral

# Etape 3 : mettre a jour le paquet
su -s /bin/bash -c \
  "cd /opt/meshcentral-server && npm update meshcentral" \
  meshcentral

# Etape 4 : redemarrer
systemctl start meshcentral

# Etape 5 : verifier les logs
journalctl -u meshcentral -f
```

### Renouvellement manuel du certificat

```bash
# acme.sh renouvelle automatiquement. En cas de besoin manuel :
~/.acme.sh/acme.sh --renew -d VOTRE_DOMAINE.duckdns.org --force
```

### Commandes de maintenance courantes

```bash
# Statut general
systemctl status meshcentral mongod

# Espace disque
df -h /

# Memoire
free -h

# Lister les sauvegardes
ls -lh /var/backups/meshcentral/

# Verifier le certificat
echo | openssl s_client -connect VOTRE_DOMAINE.duckdns.org:443 \
  -servername VOTRE_DOMAINE.duckdns.org 2>/dev/null \
  | openssl x509 -noout -dates

# Redemarrer apres modification du config.json
systemctl restart meshcentral
```

---

## Résumé des ports

| Port  | Usage                                  | Accessibilite        |
|-------|----------------------------------------|----------------------|
| 22    | SSH (administration serveur)           | Internet (restreint) |
| 80    | HTTP (redirection vers HTTPS)          | Internet             |
| 443   | HTTPS (console web et agents)          | Internet             |
| 4433  | Relay bureau distant (VNC, RDP, AMT)   | Internet             |
| 27017 | MongoDB                                | Localhost uniquement |

---

## Checklist de securite finale

Verifiez chaque point avant de considerer l'installation terminee :

- [ ] MeshCentral tourne en tant que `meshcentral`, jamais `root`
- [ ] MongoDB ecoute uniquement sur `127.0.0.1:27017`
- [ ] Pare-feu actif avec seulement les ports 22, 80, 443, 4433
- [ ] `newAccounts: false` apres creation du compte administrateur
- [ ] Certificat TLS valide (pas auto-signe MeshCentralRoot)
- [ ] Sauvegardes configurees, testees et copiees hors du serveur
- [ ] Mot de passe fort sur le compte administrateur
- [ ] 2FA active sur le compte administrateur (recommande)
- [ ] SSH : connexion root desactivee

---

## References

- Documentation officielle MeshCentral : https://docs.meshcentral.com
- Code source MeshCentral : https://github.com/Ylianst/MeshCentral
- Stylish UI : https://github.com/Melo-Professional/MeshCentral-Stylish-UI
- acme.sh : https://github.com/acmesh-official/acme.sh
- DuckDNS : https://www.duckdns.org

---

*Guide teste sur Ubuntu 24.04.3 LTS - MeshCentral v1.2.1 - Node.js v20.20.2 - MongoDB 8.0*
