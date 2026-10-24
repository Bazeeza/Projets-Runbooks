# Zabbix — Travail pratique final

[← Retour au cours 420-H63](../README.md)

> [!NOTE]
> **Document à compléter.** Ce dossier ne contient encore aucun livrable (ni configuration, ni capture, ni résultat). Le plan ci-dessous fixe la structure attendue ; aucune section ne doit être remplie sans les preuves correspondantes.

## Prérequis déjà documentés

| Étape | Document existant |
|---|---|
| Réseau Cisco (NAT, VLAN, SNMP v2c) | [ArchitectureReseau.md](../ArchitectureReseau.md) |
| Serveur Zabbix 7.0 LTS sur AlmaLinux 9 | [Installation Zabbix-Server (AlmaLinux-9).md](<../ZABBIX-LAB-1/Installation Zabbix-Server (AlmaLinux-9).md>) |
| Agents Linux et Windows | [ZABBIX-LAB-1](../ZABBIX-LAB-1/README.md) |

## Plan du livrable (à compléter)

| Section | Contenu attendu | État |
|---|---|---|
| 1. Contexte et objectif | Ce que l'on supervise et pourquoi | À compléter |
| 2. Topologie | Schéma du réseau supervisé, plan d'adressage | À compléter |
| 3. Hôtes supervisés | Liste des hôtes, interface (agent ou SNMP), modèle appliqué | À compléter |
| 4. Éléments et déclencheurs | Items retenus, seuils *warning* / *critical* et justification de chaque seuil | À compléter |
| 5. Alertes | Média, action et destinataire des notifications | À compléter |
| 6. Tableau de bord | Widgets choisis et capture du tableau de bord | À compléter |
| 7. Tests | Panne simulée (ex. arrêt d'un agent), alerte reçue, retour à la normale | À compléter |
| 8. Dépannage | Problèmes rencontrés et solutions | À compléter |

## Référence

- [Documentation Zabbix 7.0 — Triggers](https://www.zabbix.com/documentation/7.0/en/manual/config/triggers)
- [Documentation Zabbix 7.0 — Notifications](https://www.zabbix.com/documentation/7.0/en/manual/config/notifications)
