# 420-H34-RO — Utilitaires réseaux avancés

![Bash](https://img.shields.io/badge/Bash-Ubuntu%2024.04-3fe0a0?style=flat-square)
![PowerShell](https://img.shields.io/badge/PowerShell-Windows%2011-2b9dff?style=flat-square)
![Python](https://img.shields.io/badge/Python-API%20Asana-ffb454?style=flat-square)
![CIS Benchmark](https://img.shields.io/badge/CIS-Benchmark-c792ea?style=flat-square)

[← Retour à l'accueil du dépôt](../README.md)

## Objectif du cours

Écrire des **scripts d'automatisation** pilotés par un fichier **XML** : un script Python qui alimente l'outil de gestion de projet Asana, puis deux scripts de **durcissement** (Bash et PowerShell) qui vérifient et corrigent des règles du **CIS Benchmark**.

## Contenu

### TP1 — Automatisation d'Asana (Python)

| Document | Contenu |
|---|---|
| [as_xml_final.py](TP1_ASANA/as_xml_final.py) | Script qui lit un fichier XML et crée projets, sections, tâches et sous-tâches dans Asana avec la bibliothèque Python officielle `asana` |
| [Procedure_Script-Utilisation.md](TP1_ASANA/Procedure_Script-Utilisation.md) | Procédure pour installer les prérequis et exécuter le script (macOS) |
| [Strategie_Remise-1.md](TP1_ASANA/Strategie_Remise-1.md) | Stratégie de départ : découpage du projet en étapes |
| [Strategie_Remise-2.md](TP1_ASANA/Strategie_Remise-2.md) | Retour réflexif : comparaison entre la stratégie prévue et celle réellement suivie |

### TP2 — Durcissement CIS Benchmark (Bash et PowerShell)

| Système | Script | Fichier de règles | Guide |
|---|---|---|---|
| Ubuntu Desktop 24.04 | [AzeezScriptLinux.sh](TP2_CIS/CIS-Linux-24/AzeezScriptLinux.sh) | [config_linux.xml](TP2_CIS/CIS-Linux-24/config_linux.xml) | [Guide-Script-Ubuntu.md](TP2_CIS/CIS-Linux-24/Guide-Script-Ubuntu.md) |
| Windows 11 | [AzeezScriptWin.ps1](TP2_CIS/CIS-Windows-11/AzeezScriptWin.ps1) | [config_windows.xml](TP2_CIS/CIS-Windows-11/config_windows.xml) | [Guide-Script-Windows.md](TP2_CIS/CIS-Windows-11/Guide-Script-Windows.md) |

Les deux scripts partagent les mêmes options :

| Option | Rôle |
|---|---|
| `-f <fichier.xml>` | Fichier de règles à appliquer |
| `-v` | **Validation** : vérifie la conformité sans rien modifier (utilisateur standard suffisant) |
| `-c` | **Correction** : vérifie et corrige les écarts (exige `sudo` ou une console administrateur) |
| `-q`, `-s <fichier>`, `-2` | Options d'affichage et d'enregistrement du résultat, détaillées dans chaque guide |

Exemple, en lecture seule :

```bash
./AzeezScriptLinux.sh -f config_linux.xml -v
```

```powershell
.\AzeezScriptWin.ps1 -f .\config_windows.xml -v
```

> [!NOTE]
> Lancez toujours une **validation** (`-v`) avant une correction (`-c`), et testez d'abord sur une machine virtuelle : la correction modifie la configuration du système (paquets, `sysctl`, registre, pare-feu, audit).

## Technologies

Bash · PowerShell · Python (bibliothèque `asana`, `argparse`, `xml.etree`) · XML · CIS Benchmark (Ubuntu 24.04, Windows 11)
