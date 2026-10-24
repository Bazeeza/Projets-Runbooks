# 420-H63-RO — Supervision de réseaux locaux

![Cisco IOS](https://img.shields.io/badge/Cisco-IOS-2b9dff?style=flat-square)
![Zabbix 7.0 LTS](https://img.shields.io/badge/Zabbix-7.0%20LTS-3fe0a0?style=flat-square)
![AlmaLinux 9](https://img.shields.io/badge/AlmaLinux-9-ffb454?style=flat-square)
![SNMP v2c](https://img.shields.io/badge/SNMP-v2c-c792ea?style=flat-square)

[← Retour à l'accueil du dépôt](../README.md)

## Objectif du cours

Mettre en place un petit réseau local sur **équipements Cisco physiques** (un routeur, un commutateur), puis le **superviser** : inventaire SNMP des équipements réseau et supervision des postes et serveurs avec **Zabbix**.

## Contenu

| Document | Ce qu'il contient |
|---|---|
| [ArchitectureReseau.md](ArchitectureReseau.md) | Câblage, réinitialisation et configuration du routeur et du commutateur : NAT/PAT vers le réseau du département, sous-interface 802.1Q (VLAN 2), trunk, communautés **SNMP v2c** pour l'inventaire |
| [ZABBIX-LAB-1/](ZABBIX-LAB-1/README.md) | Installation du serveur Zabbix 7.0 LTS sur AlmaLinux 9 et des agents Linux (Ubuntu) et Windows |
| [ZABBIX-LAB-2/](ZABBIX-LAB-2/README.md) | Laboratoire 2 — documentation **à compléter** |
| [ZABBIX-TP-FINALE/](ZABBIX-TP-FINALE/README.md) | Travail pratique final — documentation **à compléter** |

## Technologies

| Domaine | Outils |
|---|---|
| Réseau | Cisco IOS, NAT/PAT (`ip nat inside/outside`, `overload`), VLAN 802.1Q, trunk, client DHCP sur l'interface WAN |
| Supervision | Zabbix Server 7.0 LTS, Zabbix Agent (Linux) et Agent 2 (Windows), SNMP v2c |
| Systèmes | AlmaLinux 9, MariaDB, Apache/PHP (frontend Zabbix), Ubuntu Desktop, Windows 10/11 |

## Ordre de lecture conseillé

1. Construire le réseau avec [ArchitectureReseau.md](ArchitectureReseau.md).
2. Installer le serveur, puis les agents, avec [ZABBIX-LAB-1](ZABBIX-LAB-1/README.md).
3. Ajouter l'inventaire SNMP des équipements (section SNMP d'[ArchitectureReseau.md](ArchitectureReseau.md)).

> [!NOTE]
> Les adresses IP de ce dossier sont des adresses privées de laboratoire (RFC 1918). Les communautés SNMP v2c circulent en clair : en production, on utiliserait SNMP v3 (authentification et chiffrement).
