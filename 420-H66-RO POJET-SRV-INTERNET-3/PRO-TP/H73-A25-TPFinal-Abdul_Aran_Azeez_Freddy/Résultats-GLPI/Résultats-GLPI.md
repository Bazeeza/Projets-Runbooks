# Travail Pratique Final – Preuves d’installation et de fonctionnement (GLPI)

**Auteur / But et schéma de planification**

| Élément       | Contenu |
|-------------|---------|
| **Référent**  | Preuves d’installation et de fonctionnement du service **GLPI** hébergé sur AWS (Compte 2 / us-west-2). |
| **Émetteur**  | **Abdul-Bariu, Freddy, Abdul-Majid et Aran** |
| **Message**   | Fournir les preuves : service installé, service actif, certificat TLS, inventaire (agent) et présence des équipements dans GLPI. |
| **Récepteur** | M. Jérémy Massinon |
| **Canal**     | Dépôt GitLab |
| **Code**      | Français |
| **Références** | [AWS EC2](https://docs.aws.amazon.com/fr_fr/ec2/) · [GLPI](https://glpi-project.org/) |

---

## 1) Contexte – Machine support

GLPI est hébergé sur une instance EC2 du **Compte 2** dans la région **us-west-2 (Oregon)**.  
Les preuves ci-dessous montrent l’état des services côté serveur, la présence de GLPI, et le fonctionnement de l’inventaire.

---

## 2) Preuves – Services installés et actifs (GLPI)

### Résultat attendu :
Le service web utilisé par GLPI (Apache) est en état **active (running)**.

![Capture 14](https://i.postimg.cc/pdGHMS7h/Screenshot-2025-12-16-at-9-22-53-AM.png)

**Explication :**  
Cette image montre le statut du service web côté serveur. Le service est démarré et en exécution, ce qui confirme que la partie serveur web nécessaire à GLPI est active.

---

## 4) Preuves – GLPI installé (fichiers / version)

### 4.2 Version GLPI / version PHP

### Résultat attendu :
Une sortie qui confirme la présence des éléments GLPI (référence de version si trouvée) ainsi que la version de PHP installée.

![Capture 15](https://i.postimg.cc/CKPgp2tf/Screenshot-2025-12-16-at-9-24-11-AM.png)

**Explication :**  
Cette image montre la vérification côté serveur de la version de PHP ainsi qu’une recherche d’informations de version côté GLPI. Cela confirme que l’environnement applicatif (PHP) requis par GLPI est bien présent.

---

## 5) Preuves – Certificat TLS présent côté application

### 5.1 Connexion sécurisée (HTTPS)

### Résultat attendu :
La connexion au site GLPI doit être indiquée comme **sécurisée** (HTTPS actif).

![Capture 22](https://i.postimg.cc/bvfntBV7/Screenshot-2025-12-15-at-5-18-45-PM.png)

**Explication :**  
Cette image montre que l’accès à l’interface GLPI est bien en HTTPS et que le navigateur indique une connexion sécurisée.

### 5.2 Certificat reconnu (Let’s Encrypt)

### Résultat attendu :
Le certificat doit être émis par une autorité reconnue (ex : **Let’s Encrypt**) et afficher des informations cohérentes (émetteur, domaine, validité).

![Capture 23](https://i.postimg.cc/VNPtCVHy/Screenshot-2025-12-15-at-5-22-14-PM.png)

**Explication :**  
Cette image montre le détail du certificat TLS utilisé. On y voit l’émetteur (Let’s Encrypt) et les informations du certificat, ce qui prouve que le chiffrement TLS est bien basé sur un certificat reconnu.

---

## 7) Preuves – Inventaire (Agent / collecte)

### 7.1 Présence des équipements inventoriés (côté GLPI)

### Résultat attendu :
Dans GLPI, on doit voir des équipements/actifs listés dans l’inventaire (machines enregistrées).

![Capture 18](https://i.postimg.cc/qRNdJLVQ/Screenshot-2025-12-16-at-9-31-53-AM.png)

**Explication :**  
Cette image montre le tableau de bord / la liste des éléments inventoriés dans GLPI. La présence d’équipements confirme que l’inventaire est bien reçu et enregistré côté serveur.

### 7.2 Agent d’inventaire actif (preuve côté serveur)

### Résultat attendu :
L’agent utilisé pour l’inventaire doit être présent et en état **running** (ou service actif).

![Capture 16](https://i.postimg.cc/zftrYQMW/Screenshot-2025-12-16-at-9-25-00-AM.png)

**Explication :**  
Cette image montre le statut de l’agent d’inventaire (ou du service associé) côté serveur, en exécution. Cela prouve que l’outil de collecte est bien actif.

### 7.3 Liste des équipements inventoriés (détail)

### Résultat attendu :
Une liste d’équipements doit être visible dans GLPI (nom de machine / type / informations de base).

![Capture 17](https://i.postimg.cc/qRNdJLVn/Screenshot-2025-12-16-at-9-31-41-AM.png)

**Explication :**  
Cette image montre la liste des équipements présents dans GLPI. Cela confirme que l’inventaire a bien été importé et que les éléments sont consultables dans l’interface.

---