# Travail Pratique Final – AWS – Architecture réseau + groupes de sécurité (EC2-Nextcloud)

**Auteur / But et schéma de planification**

| Élément       | Contenu |
|-------------|---------|
| **Référent**  | Présentation et documentation de l’instance **EC2-Nextcloud** hébergée sur **AWS** (Compte 1 / **N. Virginia – us-east-1**). |
| **Émetteur**  | **Abdul-Bariu, Freddy, Abdul-Majid et Aran** |
| **Message**   | Documenter les résultats de l’architecture réseau (**VPC / Subnet / IP**) et les **règles de pare-feu (Security Groups)** associées au serveur Nextcloud. |
| **Récepteur** | M. Jérémy Massinon |
| **Canal**     | Dépôt GitLab |
| **Code**      | Français |
| **Références** | [AWS EC2](https://docs.aws.amazon.com/fr_fr/ec2/) · [Nextcloud Docs](https://docs.nextcloud.com/) |

---

## 1) Architecture réseautique et configuration de base (EC2-Nextcloud)

### 1.1 Identité / hébergement
- **Fournisseur :** AWS  
- **Service :** EC2  
- **Nom instance :** `EC2-Nextcloud`  
- **ID instance :** `i-0813fac2747b240c7`  
- **Compte / Région :** Compte 1 – **United States (N. Virginia) – us-east-1**  

### 1.2 Machine / système
- **Type d’instance :** `t2.micro` *(1 vCPU)*  
- **Plateforme :** Linux/UNIX  
- **Système :** Ubuntu Server **22.04 LTS (Jammy)**  
  - **AMI ID :** `ami-0c398cb65a93047f2`  
  - **AMI name :** `ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20251015`

### 1.3 Réseau (VPC / Subnet / adressage)
- **VPC :** `vpc-04647d56f2c618f05` *(VPC-Compte1)*  
- **Subnet :** `subnet-045edceafb5d40b49` *(Public_compte1)*  
- **Adresse IPv4 privée :** `10.0.1.221`  
- **Adresse IPv4 publique (Elastic IP) :** `54.85.179.196`  
- **DNS privé :** `ip-10-0-1-221.ec2.internal`  

### 1.4 Accès / paramètres instance
- **Paire de clés :** `ssh_compte1`  
- **IMDSv2 :** `Required`  

### 1.5 Service hébergé
- **Service:** Nextcloud (service web / stockage)

---

## 2) Preuve – Instance EC2 (console AWS)

- **Détails techniques de l’instance (EC2 Summary)**  
![Capture 6](https://i.postimg.cc/Dfx1M5mr/Screenshot-2025-12-15-at-4-33-24-PM.png)
---

## 3) Groupes de sécurité (pare-feu) – EC2-Nextcloud

### 3.1 Security Groups attachés
- `sg-019d883c76e93f329` (**Services-Compte1**)  
- `sg-0820d056afb7fc116` (**Admin-Compte1**)

### 3.2 Règles d’entrée (Inbound) observées

| Security Group | Port | Protocole | Source | Commentaire |
|---|---:|---|---|---|
| Services-Compte1 (sg-019d883c76e93f329) | All | ICMP | 10.8.0.0/24 | ICMP autorisé depuis le réseau VPN (subnet VPN). |
| Services-Compte1 (sg-019d883c76e93f329) | 80 | TCP | 0.0.0.0/0 | Accès Web HTTP. |
| Services-Compte1 (sg-019d883c76e93f329) | 443 | TCP | 0.0.0.0/0 | Accès Web HTTPS. |
| Services-Compte1 (sg-019d883c76e93f329) | 8065 | TCP | 0.0.0.0/0 | Règle présente (port 8065) même si elle correspond au service Mattermost. |
| Admin-Compte1 (sg-0820d056afb7fc116) | 22 | TCP | 0.0.0.0/0 | Accès SSH autorisé depuis Internet (à valider selon les exigences du TP). |

### 3.3 Règles de sortie (Outbound) observées

| Security Group | Port | Protocole | Destination | Commentaire |
|---|---:|---|---|---|
| Services-Compte1 + Admin-Compte1 | All | All | 0.0.0.0/0 | Sorties autorisées vers Internet (règle large). |

---

## 4) Preuve – Security Groups (console AWS)

- **Capture des règles Inbound/Outbound (onglet Security)**  
![cap-sg-nextcloud](https://i.postimg.cc/xdGzy3Wz/Screenshot-2025-12-15-at-5-44-32-PM.png)
