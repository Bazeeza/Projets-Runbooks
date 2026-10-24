# Travail Pratique Final – AWS CloudWatch – Tableaux de bord, métriques et alertes (TPFinal-Alerts)

**Auteur / But et schéma de planification**

| Élément       | Contenu |
|-------------|---------|
| **Référent**  | Preuves de supervision CloudWatch : tableaux de bord, métriques (CPU, disque, bande passante) et alertes (notifications) pour les services du TP Final. |
| **Émetteur**  | **Abdul-Bariu, Freddy, Abdul-Majid et Aran** |
| **Message**   | Prouver la mise en place d’un dashboard CloudWatch et des alertes (seuils) pour chaque service de l’infrastructure. |
| **Récepteur** | M. Jérémy Massinon |
| **Canal**     | Dépôt GitLab |
| **Code**      | Français |
| **Références** | [AWS CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/) · [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html) |

---

## 1) Dashboard CloudWatch utilisé

- **Région :** United States (N. Virginia) `us-east-1`  
- **Dashboard :** `TPFinal-Alerts`
---

## 2) Métriques affichées sur le dashboard (preuves)

### 2.1 Performance EC2 (CPUUtilization)

Instances suivies :
- `i-0813fac2747b240c7` (EC2-Nextcloud)
- `i-0acc90a4d67f9971f` (EC2-Mattermost)

### Résultat attendu :
- Le dashboard doit afficher **CPUUtilization** pour chaque instance EC2.
- Le dashboard doit afficher **NetworkIn** et **NetworkOut** pour mesurer l’utilisation réseau (bande passante).
- Le dashboard doit afficher une métrique liée au disque (ex : **FreeStorageSpace**) pour RDS.
- Le dashboard doit afficher **CPUUtilization** pour RDS (surveillance performance DB).
---
![Capture 20](https://i.postimg.cc/rpRDNLRv/Screenshot-2025-12-16-at-5-40-22-PM.png)
---
Explication : ce widget montre la métrique CloudWatch **CPUUtilization** des instances EC2 Nextcloud et Mattermost, ce qui permet d’évaluer la performance de la machine.
---

---

## 3) Alertes et notifications (seuils)

Le TP demande des notifications en cas de dépassement des seuils.  
Pour la correction, il faut fournir des preuves d’alarmes CloudWatch (et leur action de notification).

### 3.1 Alertes (EC2 – Nextcloud et Mattermost)
- **CPUUtilization** : alarme si CPU > 80% pendant 5 minutes
- **NetworkOut / NetworkIn** : alarme si dépassement d’un seuil (ex : pic anormal)
- **Disque** : nécessite souvent CloudWatch Agent (si on veut % disque sur EC2)

### 4.2 Alertes (RDS – MySQL)
- **FreeStorageSpace** : alarme si espace libre < 5 GiB
- **CPUUtilization** : alarme si CPU > 80% pendant 5 minutes

---
