# TP2 — Nextcloud, Jellyfin et Mattermost sur AWS

[← Retour au cours 420-H66](../../README.md)

## Objectif

Déployer trois services web sur des instances **EC2**, chacun associé à un service AWS différent : stockage **S3** pour Nextcloud, supervision **CloudWatch** pour Jellyfin, base de données managée **RDS PostgreSQL** pour Mattermost. Chaque service est publié en HTTPS.

## Documents

| Partie | Document | Contenu |
|---|---|---|
| 2.1 | [Résultats-Nextcloud.md](Travail_Pratique-2.1/Résultats-Nextcloud.md) | Instance EC2 Ubuntu Server, Nextcloud, certificat Let's Encrypt, stockage externe S3 |
| 2.1 | [del-cap(.png).md](<Travail_Pratique-2.1/del-cap(.png).md>) | Brouillon : suite de captures d'écran de la progression du TP |
| 2.2 | [Résultats-ArchitectureReseau.md](Travail_Pratique-2.2/Résultats-ArchitectureReseau.md) | Architecture réseau et groupe de sécurité du serveur Jellyfin |
| 2.2 | [Résultats-CloudWatch.md](Travail_Pratique-2.2/Résultats-CloudWatch.md) | Déploiement de Jellyfin en HTTPS et supervision CloudWatch |
| 2.3 | [Résultats-ArchitectureReseau.md](Travail_Pratique-2.3/Résultats-ArchitectureReseau.md) | VPC, DNS, TLS, groupes de sécurité et accès RDS pour Mattermost |
| 2.3 | [Résultats-MatterMost.md](Travail_Pratique-2.3/Résultats-MatterMost.md) | Déploiement de Mattermost relié à RDS PostgreSQL, notifications par courriel |

## Technologies

AWS EC2 · VPC · groupes de sécurité · S3 · CloudWatch · RDS PostgreSQL · Nextcloud · Jellyfin · Mattermost · Let's Encrypt
