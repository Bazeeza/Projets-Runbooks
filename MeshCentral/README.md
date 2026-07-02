# MeshCentral — Guide d'Installation Entreprise
**Présentation et bénéfices d'un serveur de gestion à distance auto-hébergé**

| Élément       | Contenu                                                                                         |
|---------------|-------------------------------------------------------------------------------------------------|
| **Référent**  | Présentation et documentation d'un serveur MeshCentral auto-hébergé sur VPS Ubuntu, sécurisé avec TLS, supervisé via systemd et sauvegardé automatiquement. |
| **Émetteur**  | Communauté open source — guide contributif public                                               |
| **Message**   | Présenter les bénéfices et le contenu du guide d'installation complet de MeshCentral en environnement entreprise ou privé. |
| **Récepteur** | Toute personne souhaitant héberger son propre serveur de gestion à distance sans abonnement     |
| **Canal**     | Dépôt GitHub public                                                                             |
| **Code**      | La langue française                                                                             |
| **Référence** | Consultez la [Documentation officielle MeshCentral](https://docs.meshcentral.com) et [MeshCentral GitHub](https://github.com/Ylianst/MeshCentral). |

---

## Qu'est-ce que MeshCentral ?

MeshCentral est une plateforme de gestion et de contrôle à distance entièrement open source, sous licence Apache 2.0, développée par Intel. Elle permet de gérer tous vos ordinateurs Windows, macOS et Linux depuis n'importe quel navigateur web, de partout dans le monde, sans frais d'abonnement et sans dépendre d'un serveur tiers.

---

## Pourquoi choisir MeshCentral ?

| Avantage              | Détail                                                                 |
|-----------------------|------------------------------------------------------------------------|
| Gratuit               | Aucun abonnement, aucune limite d'appareils                            |
| Sécurisé              | TLS, authentification à deux facteurs, chiffrement bout-en-bout        |
| Auto-hébergé          | Vos données restent sur votre propre serveur                           |
| Accessible partout    | Navigateur web, mobile, tablette, aucun logiciel client requis         |
| Multi-plateforme      | Agents disponibles pour Windows, macOS et Linux                        |
| Sans port-forwarding  | Les agents se connectent en sortant — aucune ouverture de port requise |
| Transfert de fichiers | Envoi et réception de fichiers à distance                              |
| Terminal distant      | Accès ligne de commande complet                                        |
| Enregistrement        | Journal d'audit de toutes les sessions distantes                       |
| Multi-utilisateurs    | Gestion de plusieurs techniciens avec permissions distinctes            |

---

## MeshCentral face aux alternatives payantes

| Fonctionnalité    | MeshCentral   | TeamViewer    | AnyDesk       |
|-------------------|---------------|---------------|---------------|
| Prix              | Gratuit       | ~50 $/mois    | ~15 $/mois    |
| Hébergement       | Votre serveur | Leurs serveurs| Leurs serveurs|
| Limite d'appareils| Illimité      | Limité        | Limité        |
| Propriété données | Chez vous     | Chez eux      | Chez eux      |
| Open source       | Oui           | Non           | Non           |

---

## Ce que ce guide installe

Ce guide déploie une instance MeshCentral de niveau entreprise sur un VPS Ubuntu avec :

- Certificat TLS valide via acme.sh et DuckDNS (gratuit)
- Base de données MongoDB 8.0 sécurisée sur localhost uniquement
- Pare-feu UFW et protection fail2ban
- Thème graphique moderne Stylish UI
- Sauvegardes automatiques nocturnes
- Service systemd avec redémarrage automatique
- Dossier isolé séparé de vos autres services

---

## Prérequis

- Un VPS Linux (Ubuntu 22.04 ou 24.04 LTS recommandé)
- Minimum 2 GB de RAM et 20 GB de disque
- Un nom de domaine (gratuit via DuckDNS ou payant)
- Accès SSH au serveur

---

## Structure du dépôt

```
README.md                    # Ce fichier — présentation et bénéfices
GUIDE-INSTALLATION.md        # Guide complet étape par étape
```

---

## Corrections intégrées

Ce guide documente et corrige les problèmes réels rencontrés lors de l'installation :

| Problème rencontré                            | Correction appliquée                              |
|-----------------------------------------------|---------------------------------------------------|
| MongoDB 7.0 incompatible avec Ubuntu 24.04    | Utilisation de MongoDB 8.0                        |
| Redirection `>` échoue avec sudo              | Utilisation de `tee` dans toutes les étapes       |
| `/etc/resolv.conf` cassé sur Ubuntu 24.04     | Gestion via systemd-resolved uniquement           |
| certbot-dns-duckdns peu fiable                | Remplacement par acme.sh                          |
| Port 4433 manquant — bureau distant échoue    | Port 4433 ajouté dans UFW dès le départ           |
| Agent Windows ne capture pas le bureau        | Installation obligatoire en tant qu'administrateur|
| macOS — permissions TCC refusées par SIP      | Procédure manuelle via Réglages Système           |
| RDP — écran blanc après login                 | Désactivation de NLA documentée                   |

---

## Licence

Ce guide est publié sous licence MIT — libre d'utilisation, modification et redistribution.

MeshCentral est sous licence Apache 2.0 — [github.com/Ylianst/MeshCentral](https://github.com/Ylianst/MeshCentral)

---

## Crédits

- MeshCentral par Ylian Saint-Hilaire (Intel) — [meshcentral.com](https://meshcentral.com)
- MeshCentral Stylish UI par Melo-Professional — [github.com/Melo-Professional/MeshCentral-Stylish-UI](https://github.com/Melo-Professional/MeshCentral-Stylish-UI)
- acme.sh — [github.com/acmesh-official/acme.sh](https://github.com/acmesh-official/acme.sh)
- DuckDNS — [duckdns.org](https://www.duckdns.org)

---

*Guide testé sur Ubuntu 24.04.3 LTS avec MeshCentral v1.2.1*