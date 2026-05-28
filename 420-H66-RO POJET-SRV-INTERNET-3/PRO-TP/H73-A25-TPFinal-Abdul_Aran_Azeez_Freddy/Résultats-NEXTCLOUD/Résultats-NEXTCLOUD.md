# Travail Pratique Final – Preuves d’installation et de fonctionnement (Nextcloud)

**Auteur / But et schéma de planification**

| Élément       | Contenu |
|-------------|---------|
| **Référent**  | Preuves d’installation et de fonctionnement du service **Nextcloud** hébergé sur AWS (Compte 1 / us-east-1). |
| **Émetteur**  | **Abdul-Bariu, Freddy, Abdul-Majid et Aran** |
| **Message**   | Fournir les preuves : service installé, service actif, statut applicatif (occ), certificat TLS côté serveur, stockage externe (S3) et inventaire (agent). |
| **Récepteur** | M. Jérémy Massinon |
| **Canal**     | Dépôt GitLab |
| **Code**      | Français |
| **Références** | [AWS EC2](https://docs.aws.amazon.com/fr_fr/ec2/) · [Nextcloud Docs](https://docs.nextcloud.com/) |

---

## 3) Intro et contexte – Machine support

Nextcloud est déployé sur une instance EC2 dans le **Compte 1 (us-east-1)**.  
Les preuves ci-dessous montrent le statut applicatif, le certificat TLS côté serveur et la configuration du stockage/externe.

---


## 4) Preuves – Accès applicatif Nextcloud (côté application)

### 4.1 Statut Nextcloud (CLI / `occ`)

### Résultat attendu :
- `installed: true`
- `version` affichée
- `maintenance: false` (ou équivalent)

![Capture 9](https://i.postimg.cc/QMx3PD63/Screenshot-2025-12-16-at-9-04-02-AM.png)

**Explication :**  
Cette image montre la sortie de la commande `occ status`. On y voit que Nextcloud est bien installé et que l’application répond correctement côté serveur.

---

## 5) Preuves – Certificat TLS présent côté serveur (côté OS)

### 5.1 Certificat Let’s Encrypt

### Résultat attendu :
- Le nom de domaine apparaît dans la liste des certificats
- Les dates de validité sont visibles

![Capture 10](https://i.postimg.cc/N0fcVtNs/Screenshot-2025-12-16-at-9-07-19-AM.png)
---
![Capture 24](https://i.postimg.cc/FKXSLBnr/Screenshot-2025-12-15-at-5-25-35-PM.png)
---
![Capture 25](https://i.postimg.cc/9fH97nNX/Screenshot-2025-12-15-at-5-27-19-PM.png)
---
**Explication :**  
Cette image montre la liste des certificats présents côté serveur (Certbot). Elle prouve que le certificat TLS est bien installé et qu’il est valide (dates visibles).

---

## 6) Preuves – Stockage externe S3 utilisé par Nextcloud

### 6.1 Stockage externe / connectivité (S3)

### Résultat attendu :
Une preuve côté serveur que la configuration liée au stockage externe (S3) est présente et/ou qu’il y a une connectivité vers les services nécessaires.

![Capture 8](https://i.postimg.cc/yNYH5Kfz/Screenshot-2025-12-16-at-9-01-11-AM.png)

**Explication :**  
Cette image montre une vérification côté serveur liée à la configuration et/ou à la connectivité vers les services externes utilisés par Nextcloud (ex : stockage externe). Elle sert de preuve que l’intégration est en place.

---

## 7) Preuves – Inventaire (agent)

### Résultat attendu :
L’agent d’inventaire doit être installé/présent et prêt à communiquer (preuve côté serveur/poste selon votre choix).

![Capture 11](https://i.postimg.cc/cJ9SGzjy/Screenshot-2025-12-16-at-9-11-00-AM.png)

**Explication :**  
Cette image montre une preuve liée à l’agent d’inventaire (présence / statut / installation). Elle confirme que la collecte d’inventaire est possible.

---