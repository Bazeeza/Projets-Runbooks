# Travail Pratique Final – AWS – Architecture réseau + groupes de sécurité (RDS-MySQL – Compte 1)

**Auteur / But et schéma de planification**

| Élément       | Contenu |
|-------------|---------|
| **Référent**  | Présentation et documentation de l’instance **AWS RDS MySQL** `rds-sql-compte1` hébergée sur **AWS** (Compte 1 / **N. Virginia – us-east-1**), déployée en réseau privé via **VPC / DB Subnet Group / Security Group**. |
| **Émetteur**  | **Abdul-Bariu, Freddy, Abdul-Majid et Aran** |
| **Message**   | Documenter les résultats de l’architecture réseau (**endpoint, VPC, subnets, accessibilité**) et l’association de sécurité (**Security Group RDS**) pour la base de données. |
| **Récepteur** | M. Jérémy Massinon |
| **Canal**     | Dépôt GitLab |
| **Code**      | Français |
| **Références** | [AWS RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/) · [MySQL](https://dev.mysql.com/doc/) |

---

## 1) Architecture réseautique et configuration de base (RDS – MySQL)

### 1.1 Identité / hébergement
- **Fournisseur :** AWS  
- **Service :** RDS  
- **DB identifier :** `rds-sql-compte1`  
- **Compte / Région :** Compte 1 – **United States (N. Virginia) – us-east-1**  
- **Availability Zone :** `us-east-1c`  
- **Statut :** `Available`  
- **Moteur :** `MySQL Community`  
- **Version moteur :** `8.0.43`  

### 1.2 Taille / ressources
- **Classe RDS :** `db.t3.micro`  
- **vCPU :** `2`  
- **RAM :** `1 GB`  
- **Multi-AZ :** `No`  

### 1.3 Stockage
- **Chiffrement :** `Enabled`  
- **KMS key :** `aws/rds`  
- **Type de stockage :** `General Purpose SSD (gp3)`  
- **Taille :** `25 GiB`  
- **Provisioned IOPS :** `3000 IOPS`  
- **Throughput :** `125 MiBps`  
- **Autoscaling :** `Enabled`  
- **Seuil max :** `1000 GiB`  

---

## 2) Réseau (endpoint / VPC / subnets)

### 2.1 Endpoint & port
- **Endpoint :** `rds-sql-compte1.cfu4ea6qgv4o.us-east-1.rds.amazonaws.com`  
- **Port :** `3306`  
- **Network type :** `IPv4`

### 2.2 Réseau AWS
- **VPC :** `VPC-Compte1` (`vpc-04647d56f2c618f05`)  
- **DB Subnet group :** `db-subnet-group-compte1`  
- **Subnets :**
  - `subnet-0abaa98e0d318e151`
  - `subnet-0e37cdf7112e6358a`

---

## 3) Sécurité (Security Group / accessibilité)

### 3.1 Security Group attaché (RDS)
- **VPC security group :** `SG-DB-Compte1` (`sg-069620fc2b65cd3be`)  

### 3.2 Accessibilité publique
- **Publicly accessible :** `No`  
Cela signifie que la base de données n’est pas exposée directement sur Internet.

### 3.3 Certificat RDS (CA)
- **Certificate authority :** `rds-ca-rsa2048-g1`  

---

## 4) Preuves (console AWS)

### 4.1 Preuve – Configuration (moteur, classe, stockage)
Résultat attendu : voir le DB identifier, le moteur MySQL, la classe `db.t3.micro`, la version moteur et les paramètres de stockage.

![Capture 15](https://i.postimg.cc/KvVBZzPB/Screenshot-2025-12-15-at-5-01-15-PM-1.png)

Explication : cette capture montre la configuration de l’instance RDS `rds-sql-compte1` (MySQL 8.0.43), la classe `db.t3.micro`, et les paramètres de stockage (chiffrement activé, gp3, 25 GiB, autoscaling).

### 4.2 Preuve – Connectivity & security (endpoint, VPC, SG, “publicly accessible: No”)
Résultat attendu : voir l’endpoint RDS, le port 3306, le VPC, le DB subnet group, les subnets et le Security Group attaché, ainsi que “Publicly accessible: No”.

![Capture 17](https://i.postimg.cc/YqVYp96b/Screenshot-2025-12-15-at-5-07-28-PM.png)

Explication : cette capture montre l’endpoint `rds-sql-compte1...rds.amazonaws.com`, le port `3306`, l’association au VPC `vpc-04647d56f2c618f05`, le DB subnet group `db-subnet-group-compte1`, les subnets utilisés, et le Security Group `SG-DB-Compte1`.

