# Travail Pratique Final – Preuves d’installation et de fonctionnement (Mattermost)

**Auteur / But et schéma de planification**

| Élément        | Contenu |
|--------------|---------|
| **Référent**  | Preuves d’installation et de fonctionnement du service **Mattermost** hébergé sur AWS (Compte 1 / **us-east-1**) et relié à une base de données. |
| **Émetteur**  | **Abdul-Bariu, Freddy, Abdul-Majid et Aran** |
| **Message**   | Fournir les preuves nécessaires à la correction : machine support, service actif, conteneurs, DNS/HTTPS, base de données et inventaire (agent). |
| **Récepteur** | M. Jérémy Massinon |
| **Canal**     | Dépôt GitLab |
| **Code**      | Français |
| **Références** | [Mattermost Docs](https://docs.mattermost.com/) · [AWS EC2](https://docs.aws.amazon.com/fr_fr/ec2/) |

---

## 1) Contexte – Machine support

### Résultat attendu :
Le serveur doit montrer son identité (hostname) et confirmer qu’on est bien sur la machine Mattermost.

![Capture 5](https://i.postimg.cc/d0tYXF56/Screenshot-2025-12-16-at-8-44-41-AM.png)

**Explication :**  
Cette image montre la sortie de `hostnamectl` sur l’instance Mattermost. Elle confirme le nom d’hôte et les informations système de la machine qui héberge le service.

---

## 2) Preuves – Mattermost installé et en cours d’exécution

### Résultat attendu :
Les conteneurs Mattermost doivent apparaître et être en état **Up** (service réellement actif).

![Capture 7](https://i.postimg.cc/g0kW5pMb/Screenshot-2025-12-16-at-8-48-51-AM.png)

**Explication :**  
Cette image montre les conteneurs Docker liés à Mattermost et leur état. Le fait qu’ils soient en exécution confirme que Mattermost tourne sur le serveur.

---

### Résultat attendu :
Le déploiement doit montrer la présence des fichiers Docker/Compose utilisés et que le fonctionnement est cohérent côté serveur.

![Capture 3](https://i.postimg.cc/vmHsjy0k/Screenshot-2025-12-16-at-8-37-02-AM.png)

**Explication :**  
Cette image montre l’environnement Docker/Compose (fichiers/structure) qui permet de démarrer Mattermost. Cela prouve que la configuration du service est bien présente sur la machine.

---

## 3) Preuves – DNS et HTTPS (Mattermost)

### Résultat attendu :
Le service doit être accessible via un nom de domaine et l’accès doit être sécurisé en HTTPS avec un certificat reconnu.

![Capture 26](https://i.postimg.cc/fbQd9rgt/Screenshot-2025-12-15-at-5-30-23-PM.png)

**Explication :**  
Cette image montre l’accès à Mattermost en HTTPS et indique que la connexion est sécurisée (TLS actif).

---

### Résultat attendu :
Le certificat doit être émis par une autorité reconnue (ex : Let’s Encrypt) et afficher les informations du certificat.

![Capture 27](https://i.postimg.cc/KYhTMHsT/Screenshot-2025-12-15-at-5-31-48-PM.png)

**Explication :**  
Cette image montre les détails du certificat TLS (émetteur/validité). Cela prouve que le chiffrement est fait avec un certificat reconnu.

---

## 5) Preuves – Base de données (RDS ou autre)

### Résultat attendu :
Le serveur doit montrer une preuve que Mattermost utilise une base de données (connexion/configuration ou test réseau selon votre méthode).

![Capture 19](https://i.postimg.cc/vB4dYzFz/Screenshot-2025-12-16-at-9-37-43-AM.png)

**Explication :**  
Cette image montre une preuve liée à la base de données (information de connexion, test ou configuration). Elle confirme que Mattermost est relié à une DB (RDS si utilisé).

---

## 7) Preuves – Inventaire (agent)

### Résultat attendu :
L’agent utilisé pour l’inventaire doit être installé et actif (service en exécution ou confirmation de présence).

![Capture 12](https://i.postimg.cc/W4WvcyK1/Screenshot-2025-12-16-at-9-11-35-AM.png)

**Explication :**  
Cette image montre la présence/installation de l’agent d’inventaire sur la machine. Cela sert de preuve que la collecte d’inventaire est prête côté poste/serveur.

---