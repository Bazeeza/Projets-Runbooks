# Travail Pratique Final – AWS – Réseau VPC + connexion privée point à point (Compte 2)

**Auteur / But et schéma de planification**

| Élément       | Contenu |
|-------------|---------|
| **Référent**  | Présentation et documentation du réseau **VPC-Compte2** (AWS / us-west-2) et de la connexion privée point à point via **VPC Peering** entre le Compte 2 et le Compte 1. |
| **Émetteur**  | **Abdul-Bariu, Freddy, Abdul-Majid et Aran** |
| **Message**   | Documenter les résultats de l’architecture réseau du **VPC-Compte2** (CIDR, DNS, tables de routage, subnets) et la connexion **point à point** (Peering) vers le VPC du Compte 1. |
| **Récepteur** | M. Jérémy Massinon |
| **Canal**     | Dépôt GitLab |
| **Code**      | Français |
| **Références** | [AWS VPC](https://docs.aws.amazon.com/vpc/) · [VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) |

---

## 1) Architecture réseau – VPC-Compte2 (us-west-2)

### 1.1 Identité / hébergement
- **Fournisseur :** AWS  
- **Service :** VPC  
- **Nom VPC :** `VPC-Compte2`  
- **VPC ID :** `vpc-01243f93ac907236d`  
- **Région :** `us-west-2` (Oregon)  
- **État :** `Available`

### 1.2 Adressage et paramètres DNS
- **IPv4 CIDR :** `10.1.0.0/16`  
- **DNS resolution :** `Enabled`  
- **DNS hostnames :** `Disabled`  
- **Default VPC :** `No`

---

## 2) Connexion privée point à point (VPC Peering East-West)

### 2.1 Identité de la connexion
- **Type :** VPC Peering  
- **Peering connection ID :** `pcx-0ef570ae5317bbef5`  
- **Statut :** `Active`

### 2.2 Informations Requester (Compte 1)
- **Requester owner ID :** `290336208248`  
- **Requester VPC :** `vpc-04647d56f2c618f05`  
- **Requester CIDR :** `10.0.0.0/16`  
- **Requester Region :** `us-east-1` (N. Virginia)

### 2.3 Informations Accepter (Compte 2)
- **Accepter owner ID :** `919504979086`  
- **Accepter VPC :** `vpc-01243f93ac907236d` (`VPC-Compte2`)  
- **Accepter CIDR :** `10.1.0.0/16`  
- **Accepter Region :** `us-west-2` (Oregon)  
- **ARN (vu depuis Compte 2) :** `arn:aws:ec2:us-west-2:919504979086:vpc-peering-connection/pcx-0ef570ae5317bbef5`

---

## 3) Preuves (console AWS)

### 3.1 Preuve – Détails VPC-Compte2 (CIDR, DNS, route table, ACL)
---
- Résultat attendu : voir `vpc-01243f93ac907236d`, le CIDR `10.1.0.0/16`, DNS resolution `Enabled`, DNS hostnames `Disabled`, et la table de routage principale.
---
![Capture 20](https://i.postimg.cc/NjHTLcbq/Screenshot-2025-12-15-at-5-13-56-PM.png)
---

Explication : cette capture montre les informations principales du VPC-Compte2 (CIDR, DNS, route table principale et ACL associée).

### 3.2 Preuve – Connexion point à point active (pcx-0ef570ae5317bbef5)
---
- Résultat attendu : voir le peering `pcx-0ef570ae5317bbef5` en statut `Active`, avec les deux VPC et les CIDR `10.0.0.0/16` = `10.1.0.0/16`.
---
![Capture 20](https://i.postimg.cc/G2Rv4N8K/Screenshot-2025-12-16-at-6-07-57-PM.png)
---
Explication : cette capture montre la connexion privée point à point (VPC Peering) entre le Compte 1 (us-east-1) et le Compte 2 (us-west-2) avec un statut actif.

---