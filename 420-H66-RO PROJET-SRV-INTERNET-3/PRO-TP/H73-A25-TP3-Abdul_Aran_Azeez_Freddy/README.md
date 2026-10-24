# TP3 — Vaultwarden sur AWS avec Terraform

[← Retour au cours 420-H66](../../README.md)

## Objectif

Décrire en **Terraform** l'infrastructure d'un serveur **Vaultwarden** (serveur compatible Bitwarden) sur AWS, la déployer, puis documenter la procédure et les résultats sous forme de tutoriel.

## Documents

| Document | Contenu |
|---|---|
| [Guide_Déploiement.md](Travail_Pratique-3/Guide_Déploiement.md) | Tutoriel de déploiement et résultats : prérequis, exécution des scripts Terraform, nom de domaine DuckDNS, vérifications |
| [main.tf](Travail_Pratique-3/Scripts-Terraform/main.tf) | Ressources AWS et script de démarrage de l'instance |
| [variables.tf](Travail_Pratique-3/Scripts-Terraform/variables.tf) | Variables du déploiement |
| [outputs.tf](Travail_Pratique-3/Scripts-Terraform/outputs.tf) | Valeurs affichées après `terraform apply` |

## Technologies

Terraform · AWS EC2 · VPC · groupes de sécurité · Docker · Vaultwarden · DuckDNS · HTTPS

> [!NOTE]
> Ces fichiers sont conservés dans leur état de remise. La version durcie et documentée (SSH limité à une adresse, IMDSv2, disque chiffré, image épinglée, CI) se trouve dans le dépôt [AutomationHub](https://github.com/Bazeeza/AutomationHub).
