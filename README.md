# Projets-Runbooks

![Langue](https://img.shields.io/badge/langue-fran%C3%A7ais-2b9dff?style=flat-square)
![Cisco](https://img.shields.io/badge/Cisco-IOS-3fe0a0?style=flat-square)
![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20VPC%20%7C%20RDS-ffb454?style=flat-square)
![Zabbix](https://img.shields.io/badge/supervision-Zabbix%20%7C%20CloudWatch-c792ea?style=flat-square)

> **English summary** — Hands-on runbooks written during a college diploma in network technology (DEC, Techniques de l'informatique — réseautique). They cover Cisco routing and switching (VLANs, static routing with floating routes, OSPF, NAT, ACLs), network monitoring with Zabbix and SNMP, AWS services (EC2, VPC, RDS, S3, CloudWatch, Terraform), CIS Benchmark hardening scripts in Bash and PowerShell, and a MeshCentral remote-support server. Documents are in French; each course folder has its own index README.

**Runbooks** techniques — procédures reproductibles étape par étape pour le déploiement, la configuration, la supervision et le dépannage d'infrastructures réseau et de services.

Chaque document présente le contexte, la topologie, les commandes exécutées et les résultats attendus, de façon à ce que la manipulation puisse être reproduite par un autre technicien.

## Table des matières

- [Contenu du dépôt](#contenu-du-dépôt)
  - [Supervision de réseaux locaux (420-H63)](#supervision-de-réseaux-locaux-420-h63)
  - [Utilitaires réseaux avancés (420-H34)](#utilitaires-réseaux-avancés-420-h34)
  - [Serveurs Internet sur AWS (420-H66)](#serveurs-internet-sur-aws-420-h66)
  - [Projets de réseautique 2 (420-H66)](#projets-de-réseautique-2-420-h66)
  - [MeshCentral](#meshcentral)
- [Pourquoi des runbooks ?](#pourquoi-des-runbooks-)
- [Technologies couvertes](#technologies-couvertes)
- [Compétences démontrées](#compétences-démontrées)
- [Formation](#formation)
- [Auteur](#auteur)

---

## Contenu du dépôt

| Dossier | Sujet | Index |
|---|---|---|
| `420-H63-RO SUPERVISION-RÉSEAUX-LOCAUX/` | Réseau Cisco physique et supervision Zabbix / SNMP | [README](<420-H63-RO SUPERVISION-RÉSEAUX-LOCAUX/README.md>) |
| `420-H34-RO UTILITAIRES-RÉSEAUX-AVANCÉS/` | Scripts d'automatisation et de durcissement CIS | [README](<420-H34-RO UTILITAIRES-RÉSEAUX-AVANCÉS/README.md>) |
| `420-H66-RO PROJET-SRV-INTERNET-3/` | Services Internet et infrastructure AWS | [README](<420-H66-RO PROJET-SRV-INTERNET-3/README.md>) |
| `420-H66-RO PROJETS-RÉSEAUTIQUE-2/` | Routage et sécurité Cisco (statique, OSPF, NAT, ACL) | [README](<420-H66-RO PROJETS-RÉSEAUTIQUE-2/README.md>) |
| `MeshCentral/` | Serveur de prise en main à distance sur Ubuntu | [README](MeshCentral/README.md) |

### Supervision de réseaux locaux (420-H63)

**Architecture et supervision d'un réseau local sur équipements Cisco physiques** — [index du dossier](<420-H63-RO SUPERVISION-RÉSEAUX-LOCAUX/README.md>)

- Configuration d'un routeur et d'un commutateur Cisco (IOS)
- Sous-interface **VLAN** (802.1Q) et trunking
- Traduction d'adresses **NAT/PAT** et accès Internet
- Supervision **SNMP v2c** pour l'inventaire des équipements
- Serveur **Zabbix 7.0 LTS** (AlmaLinux 9) et agents Linux et Windows
- Laboratoire 2 et travail final : plan rédigé, contenu à compléter

### Utilitaires réseaux avancés (420-H34)

**Scripts d'automatisation et de durcissement** — [index du dossier](<420-H34-RO UTILITAIRES-RÉSEAUX-AVANCÉS/README.md>)

- Durcissement selon le **CIS Benchmark** : Ubuntu 24.04 (Bash) et Windows 11 (PowerShell), modes validation et correction pilotés par un fichier XML
- Script **Python** d'automatisation d'Asana à partir d'un fichier XML

### Serveurs Internet sur AWS (420-H66)

**Services Internet et infrastructure cloud** — [index du dossier](<420-H66-RO PROJET-SRV-INTERNET-3/README.md>)

- GLPI, Nextcloud (S3), Jellyfin, Mattermost (RDS PostgreSQL) et Vaultwarden (Terraform) sur **EC2**
- Réseau **VPC**, groupes de sécurité, **VPC Peering** entre deux comptes AWS
- Supervision **CloudWatch** : tableaux de bord, métriques et alarmes

### Projets de réseautique 2 (420-H66)

**Routage et sécurité sur équipements Cisco** — [index du dossier](<420-H66-RO PROJETS-RÉSEAUTIQUE-2/README.md>)

- Projet phare : [routage de secours par distance administrative](<420-H66-RO PROJETS-RÉSEAUTIQUE-2/Route-ST/README.md>)
- Notes de cours et exercices **OSPF**, **NAT/PAT** et **ACL**

### MeshCentral

**Guide d'installation de MeshCentral sur Ubuntu** — [présentation](MeshCentral/README.md) · [guide complet](<MeshCentral/Guide installation.md>)

Procédure complète de déploiement d'une solution libre de **gestion et de prise en main à distance** de postes de travail : installation, configuration du serveur, déploiement des agents et sécurisation de l'accès.

---

## Pourquoi des runbooks ?

Une infrastructure qu'on ne peut pas reconstruire n'est documentée qu'à moitié. Chaque runbook de ce dépôt vise trois objectifs :

1. **Reproductibilité** — un technicien peut refaire la manipulation sans connaissance préalable du contexte
2. **Traçabilité** — les commandes exactes et les résultats attendus sont consignés
3. **Transfert de connaissances** — la logique derrière chaque choix technique est expliquée, pas seulement la commande

---

## Technologies couvertes

**Réseau** — `Cisco IOS` · `VLAN 802.1Q` · `NAT/PAT` · `Routage statique` · `OSPF` · `ACL`

**Supervision** — `Zabbix` · `SNMP v2c` · `AWS CloudWatch`

**Cloud et automatisation** — `AWS EC2 / VPC / RDS / S3` · `Terraform` · `Bash` · `PowerShell` · `Python`

**Systèmes et services** — `Ubuntu Server` · `AlmaLinux` · `Windows 11` · `GLPI` · `Nextcloud` · `Mattermost` · `MeshCentral`

---

## Compétences démontrées

- Configuration d'équipements réseau (routeurs, commutateurs)
- Segmentation réseau, routage statique et dynamique
- Mise en place de systèmes de supervision
- Déploiement de services sur Linux et sur le cloud
- Durcissement de postes selon un référentiel (CIS)
- Rédaction de documentation technique professionnelle

---

## Formation

Projets réalisés dans le cadre du **DEC en Techniques de l'informatique (Réseautique)** au Collège de Rosemont.

---

## Auteur

**Bariu Azeez**
Technicien en réseautique et télécommunication — Montréal, QC
GitHub : [@Bazeeza](https://github.com/Bazeeza) · Courriel : [Azeez@bazeeza.ca](mailto:Azeez@bazeeza.ca)
