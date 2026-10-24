# 420-H66-RO — Projets de réseautique 2 (Cisco)

![Cisco IOS](https://img.shields.io/badge/Cisco-IOS-2b9dff?style=flat-square)
![OSPF](https://img.shields.io/badge/Routage-OSPF%20%7C%20statique-3fe0a0?style=flat-square)
![ACL](https://img.shields.io/badge/S%C3%A9curit%C3%A9-ACL%20%7C%20NAT-ffb454?style=flat-square)
![Packet Tracer](https://img.shields.io/badge/Cisco-Packet%20Tracer-c792ea?style=flat-square)

[← Retour à l'accueil du dépôt](../README.md)

## Objectif du cours

Concevoir et configurer des réseaux d'entreprise sur équipements Cisco : VLAN et routage inter-VLAN, **routage statique** avec routes de secours, **OSPF** multi-zones, **NAT/PAT** et filtrage par **listes de contrôle d'accès (ACL)**. Chaque thème regroupe des notes de cours et des configurations d'exercices.

## Projet phare

**[Route-ST — Routage de secours par distance administrative](Route-ST/README.md)** : réseau redondant entre deux bâtiments, routes statiques flottantes, plan d'adressage, schémas et tests de bascule.

## Contenu par thème

| Thème | Documents |
|---|---|
| Routage statique | [README du projet](Route-ST/README.md) · [Configurations](Route-ST/Configurations.md) · [Notes de cours](Route-ST/NotesDeCours.md) |
| OSPF | [Notes de cours](OSPF/NotesDeCours.md) · [Exercice 2026-03-14](<OSPF/Exercice-OSPF (2026-03-14).md>) · [Exercice 2026-03-20](<OSPF/Exercice-OSPF (2026-03-20).md>) · [Exercice 2026](<OSPF/Exercice-OSPF(2026)>) · [Examen corrigé](OSPF/EXAM-OSPF-corrigé.md) |
| NAT / PAT | [Notes de cours](NAT/NotesDeCours.md) · [Configuration du TP final](NAT/TPFINAL-config.md) (ordre de configuration OSPF, types de câbles) |
| ACL | [Notes de cours](ACL/NotesDeCours.md) · [Exercice 2025-04-07](<ACL/Exercice-ACL (2025-04-07).md>) · [Exercice 2026-04-07](<ACL/Exercice-ACL (2026-04-07).md>) |
| Préparation aux examens | [PREP-2026-09-04](PREP-2026-09-04) · [PREP-2026-10-04](PREP-2026-10-04) : configurations complètes de commutateurs et routeurs |
| Plan d'étude CCNA | [CCNA](CCNA) : feuille de route personnelle (en anglais), semaine par semaine |

## Technologies

Cisco IOS · Catalyst 2960 / 3560 · ISR 1941 / 2911 · VLAN 802.1Q · routeur sur bâton · SVI · routes statiques flottantes · OSPF (DR/BDR, ABR, zones) · NAT/PAT · ACL standard et étendues · SSH · Cisco Packet Tracer

> [!NOTE]
> Les fichiers d'exercices sont des configurations brutes à copier dans la console. Les adresses sont des adresses privées de laboratoire.
