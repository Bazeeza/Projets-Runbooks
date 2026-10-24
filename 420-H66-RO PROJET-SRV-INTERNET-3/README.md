# 420-H66-RO — Projet de serveurs Internet 3 (AWS)

![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20VPC%20%7C%20RDS%20%7C%20S3-ffb454?style=flat-square)
![CloudWatch](https://img.shields.io/badge/Supervision-CloudWatch-3fe0a0?style=flat-square)
![Terraform](https://img.shields.io/badge/Terraform-IaC-c792ea?style=flat-square)
![Ubuntu](https://img.shields.io/badge/Ubuntu-Server-2b9dff?style=flat-square)

[← Retour à l'accueil du dépôt](../README.md)

## Objectif du cours

Déployer, sécuriser et superviser des **services Internet sur AWS** : inventaire (GLPI), stockage collaboratif (Nextcloud), messagerie d'équipe (Mattermost), gestionnaire de mots de passe (Vaultwarden), avec réseau VPC, groupes de sécurité, base de données managée RDS, certificats TLS et supervision CloudWatch. Travaux réalisés en équipe.

## Organisation du dossier

| Dossier | Contenu |
|---|---|
| [PRO-TP/](PRO-TP/) | Les livrables des travaux pratiques, un dossier par TP (voir le tableau ci-dessous) |
| [PRO-CloudWatch/](PRO-CloudWatch/Résultats-CloudWatch.md) | Version de présentation des résultats Jellyfin + CloudWatch (TP 2.2) |
| [PRO-MatterMost/](PRO-MatterMost/MatterMost.md) | Version de présentation des résultats Mattermost + RDS (TP 2.3) |
| [PRO-NextCloud/](PRO-NextCloud/Résultats-Nextcloud.md) | Version de présentation des résultats Nextcloud + S3 (TP 2.1, contenu identique) |

## Travaux pratiques

| TP | Sujet | Index |
|---|---|---|
| TP1 | GLPI + MySQL sur Ubuntu Server, agents GLPI Ubuntu et Windows, partage Samba | [README](PRO-TP/H73-A25-TP1-Abdul_Aran_Azeez/README.md) |
| TP2 | Nextcloud + S3, Jellyfin + CloudWatch, Mattermost + RDS PostgreSQL | [README](PRO-TP/H73-A25-TP2-Abdul_Aran_Azeez/README.md) |
| TP3 | Vaultwarden sur EC2 déployé avec Terraform | [README](PRO-TP/H73-A25-TP3-Abdul_Aran_Azeez_Freddy/README.md) |
| TP final | Infrastructure cloud de l'entreprise fictive « Jey INC. » sur deux comptes AWS reliés par VPC Peering | [README](PRO-TP/H73-A25-TPFinal-Abdul_Aran_Azeez_Freddy/README.md) |

## Technologies

| Domaine | Outils |
|---|---|
| Cloud AWS | EC2, VPC, sous-réseaux, tables de routage, groupes de sécurité, VPC Peering, RDS (MySQL, PostgreSQL), S3, CloudWatch (tableaux de bord, alarmes) |
| Services | GLPI et GLPI Agent, Nextcloud, Mattermost, Jellyfin, Vaultwarden, Samba |
| Automatisation | Terraform, Docker |
| Sécurité | Certificats TLS (Let's Encrypt), HTTPS, VPN d'administration |

> [!NOTE]
> Le déploiement Vaultwarden par Terraform est repris et durci dans le dépôt [AutomationHub](https://github.com/Bazeeza/AutomationHub) (SSH restreint, IMDSv2, disque chiffré, CI Terraform). Les fichiers du TP3 ci-dessous restent dans leur état de remise.
