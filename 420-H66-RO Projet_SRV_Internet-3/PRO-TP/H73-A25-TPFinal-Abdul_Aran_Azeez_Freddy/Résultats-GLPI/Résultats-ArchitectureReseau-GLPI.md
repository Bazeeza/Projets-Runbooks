# Travail Pratique Final – AWS – Architecture réseau + groupes de sécurité (EC2-GLPI)

**Auteur / But et schéma de planification**

| Élément       | Contenu |
|-------------|---------|
| **Référent**  | Présentation et documentation de l’instance **EC2-GLPI** hébergée sur **AWS** (Compte 2 / **Oregon – us-west-2**). |
| **Émetteur**  | **Abdul-Bariu, Freddy, Abdul-Majid et Aran** |
| **Message**   | Documenter les résultats de l’architecture réseau (**VPC / Subnet / IP**) et les **règles de pare-feu (Security Groups)** associées au serveur GLPI. |
| **Récepteur** | M. Jérémy Massinon |
| **Canal**     | Dépôt GitLab |
| **Code**      | Français |
| **Références** | [AWS EC2](https://docs.aws.amazon.com/fr_fr/ec2/) · [GLPI](https://glpi-project.org/) |

---

## 1) Architecture réseautique et configuration de base (EC2-GLPI)

### 1.1 Identité / hébergement
- **Fournisseur :** AWS  
- **Service :** EC2  
- **Nom instance :** `EC2-GLPI`  
- **ID instance :** `i-0c7eff3cde796e792`  
- **Compte / Région :** Compte 2 – **Oregon (us-west-2)**  

### 1.2 Machine / système
- **Type d’instance :** `t3.micro` (**2 vCPU**)  
- **Plateforme :** Linux/UNIX  
- **Système :** Ubuntu Server **22.04 LTS (Jammy)**  
  - **AMI ID :** `ami-03c1f788292172a4e`  
  - **AMI name :** `ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20251015`

### 1.3 Réseau (VPC / Subnet / adressage)
- **VPC :** `vpc-01243f93ac907236d` *(VPC-Compte2)*  
- **Subnet :** `subnet-04e901b03aa59456d` *(Public-Subnet-Compte2)*  
- **Adresse IPv4 privée :** `10.1.1.100`  
- **Adresse IPv4 publique (Elastic IP) :** `52.41.77.181`  
- **DNS privé :** `ip-10-1-1-100.us-west-2.compute.internal`  

### 1.4 Accès / paramètres instance
- **Paire de clés :** `ssh_compte2`  
- **IMDSv2 :** `Required`  

### 1.5 Service hébergé
- **Service de gestion d'un Parc informatique :** GLPI (interface Web + inventaire)

---

## 2) Preuve – Instance EC2 (console AWS)

- **Détails techniques de l’instance (EC2 Summary)**  
![cap-ec2-glpi](https://i.postimg.cc/m2h7fMHZ/Screenshot-2025-12-15-at-4-45-45-PM.png)

---

## 3) Groupes de sécurité (pare-feu) – EC2-GLPI

### 3.1 Security Groups attachés
- `sg-0b252c797b13377d0` (**SG-Admin-Compte2**)  
- `sg-00b48fc26b8faba7e` (**SG-Services-Compte2**)

### 3.2 Règles d’entrée (Inbound) observées

| Security Group | Port | Protocole | Source | Commentaire |
|---|---:|---|---|---|
| SG-Admin-Compte2 (sg-0b252c797b13377d0) | 22 | TCP | 0.0.0.0/0 | Accès SSH autorisé depuis Internet (à valider selon les exigences du TP). |
| SG-Services-Compte2 (sg-00b48fc26b8faba7e) | 80 | TCP | 0.0.0.0/0 | Accès Web HTTP. |
| SG-Services-Compte2 (sg-00b48fc26b8faba7e) | 443 | TCP | 0.0.0.0/0 | Accès Web HTTPS. |

### 3.3 Règles de sortie (Outbound) observées

| Security Group | Port | Protocole | Destination | Commentaire |
|---|---:|---|---|---|
| SG-Admin-Compte2 + SG-Services-Compte2 | All | All | 0.0.0.0/0 | Sorties autorisées vers Internet (règle large). |


---

## 4) Preuve – Security Groups (console AWS)

- **Capture des règles Inbound/Outbound (onglet Security)**  
![cap-sg-glpi](https://i.postimg.cc/xdVmz4Fv/Screenshot-2025-12-15-at-5-35-57-PM.png)
