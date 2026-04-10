# Installation de **Zabbix Agent** sur **Ubuntu Desktop**
Procédure validée
Compatible Ubuntu **22.04** / **24.04**. Serveur Zabbix d’exemple : **192.168.2.175**.

---

## 0) (Optionnel) Nettoyage si vous avez déjà tenté une install
```
# Arrêter d’éventuels services agents
sudo systemctl stop zabbix-agent zabbix-agent2 2>/dev/null || true

# Purger des paquets installés par erreur
sudo apt purge -y zabbix-agent zabbix-agent2 2>/dev/null || true

# Retirer un dépôt Zabbix cassé (évite les erreurs apt)
sudo rm -f /etc/apt/sources.list.d/zabbix.list
sudo apt update
```

---

## 1) Télécharger et vérifier l’archive **précompilée** (statique)
```
URL="https://cdn.zabbix.com/zabbix/binaries/stable/7.4/7.4.3/zabbix_agent-7.4.3-linux-3.0-amd64-static.tar.gz"
SHA256="a8b93bfcac932d2e26d646c32038950638cf5273e132731d40369302b484610c"

sudo apt update
sudo apt install -y curl tar

curl -L "$URL" -o /tmp/zabbix_agent.tgz
echo "${SHA256}  /tmp/zabbix_agent.tgz" | sha256sum -c -
# Résultat attendu : /tmp/zabbix_agent.tgz: Réussi
```

> Si vous avez **déjà** extrait l’archive dans `~/Téléchargements/`, adaptez la variable `ZBXDIR` à l’étape 2.

---

## 2) Déployer les fichiers de l’agent
```
# Extraire sous /opt/zabbix
sudo mkdir -p /opt/zabbix
sudo tar -xzf /tmp/zabbix_agent.tgz -C /opt/zabbix

# Pointer vers le dossier extrait (nom du type zabbix_agent-7.4.3-linux-3.0-amd64-static)
ZBXDIR=$(find /opt/zabbix -maxdepth 1 -type d -name 'zabbix_agent-*' | head -n1)
echo "Dossier extrait: $ZBXDIR"
```

Installer les binaires et préparer l’environnement :
```
# Binaires
sudo install -m 755 "$ZBXDIR/sbin/zabbix_agentd" /usr/local/sbin/
[ -f "$ZBXDIR/bin/zabbix_get" ]    && sudo install -m 755 "$ZBXDIR/bin/zabbix_get"    /usr/local/bin/
[ -f "$ZBXDIR/bin/zabbix_sender" ] && sudo install -m 755 "$ZBXDIR/bin/zabbix_sender" /usr/local/bin/

# Utilisateur et répertoires
sudo useradd --system --home /var/lib/zabbix --shell /usr/sbin/nologin --user-group zabbix 2>/dev/null || true
sudo mkdir -p /etc/zabbix /var/lib/zabbix /etc/zabbix/zabbix_agentd.d
sudo install -d -o zabbix -g zabbix -m 0755 /var/log/zabbix
sudo install -d -o zabbix -g zabbix -m 0750 /run/zabbix
```

---

## 3) Créer la configuration **minimale** (fonctionne tout de suite)
> Par défaut on loggue **en console** (LogType=console) pour éviter les soucis de droits; vous pourrez repasser en **log fichier** au §6.

```
HOST=$(hostname -s)
sudo tee /etc/zabbix/zabbix_agentd.conf >/dev/null <<EOF
PidFile=/run/zabbix/zabbix_agentd.pid
LogType=console
# Pour logs fichier plus tard : LogFile=/var/log/zabbix/zabbix_agentd.log
Server=192.168.2.175
ServerActive=192.168.2.175
Hostname=$HOST
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF
```

---

## 4) Créer le service **systemd** et démarrer
```
sudo tee /etc/systemd/system/zabbix-agent.service >/dev/null <<'EOF'
[Unit]
Description=Zabbix Agent (from static archive)
After=network-online.target
Wants=network-online.target

[Service]
User=zabbix
Group=zabbix
Type=simple
ExecStart=/usr/local/sbin/zabbix_agentd -f -c /etc/zabbix/zabbix_agentd.conf
Restart=on-failure
RuntimeDirectory=zabbix
RuntimeDirectoryMode=0750

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now zabbix-agent
sudo systemctl status zabbix-agent --no-pager
```

Si **UFW** est activé :
```
sudo ufw allow 10050/tcp comment 'Zabbix agent'
```

---

## 5) Vérifications côté **client Ubuntu**
```
# Version de l'agent (doit afficher 7.4.3)
/usr/local/sbin/zabbix_agentd -V

# Le port 10050 doit être en LISTEN
ss -lntp | grep 10050

# Journal du service (si besoin de debug)
sudo journalctl -u zabbix-agent -n 50 --no-pager
``

---

## 6) (Optionnel) Passer en **log fichier** après validation
```bash
# Basculer en log fichier
sudo sed -i 's|^LogType=.*|LogType=file|' /etc/zabbix/zabbix_agentd.conf
sudo sed -i 's|^# *LogFile=.*|LogFile=/var/log/zabbix/zabbix_agentd.log|' /etc/zabbix/zabbix_agentd.conf

# Droits (au cas où)
sudo chown zabbix:zabbix /var/log/zabbix

# Redémarrer et vérifier le log
sudo systemctl restart zabbix-agent
sudo tail -n 50 /var/log/zabbix/zabbix_agentd.log
```

---

## 7) Désinstallation (si besoin)
```
sudo systemctl disable --now zabbix-agent
sudo rm -f /etc/systemd/system/zabbix-agent.service
sudo rm -f /usr/local/sbin/zabbix_agentd /usr/local/bin/zabbix_get /usr/local/bin/zabbix_sender
sudo rm -rf /etc/zabbix /var/log/zabbix /var/lib/zabbix /run/zabbix
sudo systemctl daemon-reload
```