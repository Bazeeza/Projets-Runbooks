# TP1 — Inventaire GLPI et partage Samba

[← Retour au cours 420-H66](../../README.md)

## Objectif

Installer un serveur d'inventaire **GLPI** (avec sa base **MySQL**) sur un serveur Ubuntu hébergé sur AWS, y faire remonter un poste Ubuntu et un poste Windows grâce à **GLPI Agent**, puis mettre en place un **partage de fichiers Samba** entre une VM Windows cliente et une VM Ubuntu serveur.

## Documents

| Ordre | Document | Contenu |
|---|---|---|
| 1 | [Résultats-Installation_GLPI_Serveur_Ubuntu.md](GLPI/Résultats-Installation_GLPI_Serveur_Ubuntu.md) | Installation et configuration de MySQL et de GLPI sur Ubuntu Server (AWS) |
| 2 | [Résultats-Installation_GLPI-Agent-(Ubuntu).md](<GLPI/Résultats-Installation_GLPI-Agent-(Ubuntu).md>) | Installation de GLPI Agent sur Ubuntu et remontée de l'inventaire |
| 3 | [Résultats-Installation_GLPI-Agent-(Windows).md](<GLPI/Résultats-Installation_GLPI-Agent-(Windows).md>) | Installation de GLPI Agent sur Windows et inventaire serveur et client |
| 4 | [config_samba.md](Samba/config_samba.md) | Choix de Samba, installation des paquets et configuration du partage |

## Technologies

Ubuntu Server · AWS EC2 · MySQL · GLPI · GLPI Agent · Samba
