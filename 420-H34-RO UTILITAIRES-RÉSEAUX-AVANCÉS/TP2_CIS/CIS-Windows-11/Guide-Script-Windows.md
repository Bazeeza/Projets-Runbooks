# Guide TUTO d'utilisation du script CIS Bench Windows 11 (AzeezScriptWin.ps1)

## Schéma de planification

| Élément       | Contenu                                                                                                                                                            |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Référent**  | Un script PowerShell qui va pourvoir lit un fichier XML et applique des règles CIS Benchmark sur Windows 11 (mots de passe, verrouillage, comptes, services, firewall, audit). |
| **Émetteur**  | Moi-même.                                                                                                                                                   |
| **Message**   | Documenter clairement la procédure pour tester mon script de sécurisation CIS Windows 11.                                                                          |
| **Récepteur** | M. Gilles Lacasse                                                                                                                                                  |
| **Canal**     | Dépôt GitLab : `azeez-420_utilitaires-2/TP2_CIS_Windows`                                                                                                           |
| **Code**      | Langue française écrite.                                                                                                                                           |

---

## Prérequis

1. **Une machine Windows 11**
   * Le script est prévu pour la VM **Windows 11** utilisée au labo (B-338), mais fonctionnera aussi sur une autre Windows 11 avec les mêmes outils.

2. **Droits d’administrateur (PowerShell)**
   * Pour **lire**, le script peut fonctionner en utilisateur standard (mode `-v`).
   * Pour **corriger** (`-c`) les paramètres (registre, firewall, audit, compte Guest, etc.), **il faut** ouvrir PowerShell *en tant qu’administrateur*.

3. **PowerShell en tant que Administrateur**

   * Présent par défaut sur Windows 11 du local.
   * Veuillez bien noté que le script est stocké dans le dossier suivant et ainsi sont fichier XML sont elle ausssi 
     `azeez-420_utilitaires-2/TP2_CIS_Windows`
     
     Donc il vous faut  au minimum :

     * `AzeezScriptWin.ps1` : script principal
     * `config_windows.xml` : fichier de règles CIS

4. **Fichier XML CIS Windows 11**

   * Le fichier `config_windows.xml` contient les règles **CIS Benchmark Windows 11 Enterprise L1** suivantes :

     * 1.1.x : politique de mot de passe (history, âge max/min, longueur, complexité, etc.)
     * 1.2.x : verrouillage de compte
     * 2.3.1.x : statut du compte Guest, mot de passe vide
     * 5.11 : service Microsoft FTP (FTPSVC)
     * 9.x.x : état du firewall (Domain, Private, Public)
     * 17.x.x : audit (Credential Validation, User Account Management, Account Lockout, Logon)

---

## Pourquoi PowerShell pour ce projet ?
### Raison pédagogique (cours 420-H34-RO)

* PowerShell est un outil standard pour l’administration de Windows (surtout Windows 10/11 et bien Server).
* C’est un **langage de scripting intégré** au système, déjà installé, sans avoir à ajouter Python ou autre.

### Raison professionnelle (CIS Benchmark & sécurité)

* Les recommandations CIS pour Windows 11 se configurent via :
  * les **GPO**,
  * ou des commandes et registres Windows que PowerShell sait très bien piloter.
* PowerShell est utilisé dans les entreprises pour :
  * **standardiser** la configuration de la sécurité ;
  * **automatiser** la vérification de conformité (audit) ;
  * **corriger** rapidement plusieurs machines.
* Un script PowerShell se lance facilement par les **admins juniors** depuis une console, avec quelques paramètres (`-f`, `-v`, `-c`, etc.), sans devoir comprendre tout le code.

---

## 3. Structure du projet Windows (TP2_CIS_Windows)

Dans le dépôt GitLab `azeez-420_utilitaires-2/TP2_CIS_Windows`, la partie Windows contient typiquement :

```
TP2_CIS_Windows/
 ├─ AzeezScriptWin.ps1
 ├─ config_windows.xml
 └─ Guide-Script-Linux
```

* Le **script** lit le fichier `config_windows.xml` pour savoir **quelles règles** appliquer.
* Le **XML** est la « source de vérité » :
  si on veut changer une valeur par exemple la longueur min de mot de passe., on modifie le XML, pas le script.

---

## Préparer l’environnement sur Windows 11

### 4.1. Copier ou cloner le projet

Sur la VM Windows 11 du labo :

1. Copier le dossier `TP2_CIS_Windows` (ou `azeez-420_utilitaires-2/TP2_CIS_Windows`) dans ton profil, par exemple :

```
cd C:\Users\utilisateur
mkdir TP2_Windows -Force
cd C:\Users\utilisateur\TP2_Windows
```

2. Vérifier le contenu :

```
cd C:\Users\utilisateur\TP2_Windows
ls
```

Vous devez voir au minimum :

```
AzeezScriptWin.ps1
config_windows.xml
```

---

### Autoriser l’exécution du script (ExecutionPolicy)

PowerShell bloque parfois les scripts par sécurité.
On ne veut **pas** changer la machine pour toujours, donc on ne modifie que la **session actuelle** :

1. Ouvrir **PowerShell** (Admin selon le test).

```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
2. Taper : T pour tout

* Cela permet d’exécuter `AzeezScriptWin.ps1` **seulement dans cette session**.
* Quand on ferme la fenêtre, le paramétrage disparaît.

---

## 5. Contenu du fichier XML (config_windows.xml)

Le fichier `config_windows.xml` contient des règles de ce genre :

```
<?xml version="1.0" encoding="utf-8"?>
<config>
  <!-- Politiques de mot de passe -->
  <rule id="WIN-1.1.1" category="password" field="EnforceHistory" expected="24" />
  <rule id="WIN-1.1.2" category="password" field="MaxAge" expected="365" />
  <rule id="WIN-1.1.3" category="password" field="MinAge" expected="1" />
  <rule id="WIN-1.1.4" category="password" field="MinLength" expected="14" />
  <rule id="WIN-1.1.5" category="password" field="Complexity" expected="Enabled" />
  <rule id="WIN-1.1.6" category="password" field="RelaxMinLength" expected="Enabled" />
  <rule id="WIN-1.1.7" category="password" field="ReversibleEncryption" expected="Disabled" />

  <!-- Verrouillage de compte -->
  <rule id="WIN-1.2.1" category="lockout" field="Duration" expected="15" />
  <rule id="WIN-1.2.2" category="lockout" field="Threshold" expected="5" />
  <rule id="WIN-1.2.4" category="lockout" field="ResetCounter" expected="15" />

  <!-- Comptes -->
  <rule id="WIN-2.3.1.1" category="account" field="GuestStatus" expected="Disabled" />
  <rule id="WIN-2.3.1.2" category="account" field="LimitBlankPasswordUse" expected="Enabled" />

  <!-- Service FTP -->
  <rule id="WIN-5.11" category="service" field="FTPSVC" expected="DisabledOrNotInstalled" />

  <!-- Firewall -->
  <rule id="WIN-9.1.1" category="firewall" field="Domain" expected="On" />
  <rule id="WIN-9.2.1" category="firewall" field="Private" expected="On" />
  <rule id="WIN-9.3.1" category="firewall" field="Public" expected="On" />

  <!-- Audit -->
  <rule id="WIN-17.1.1" category="audit" field="Credential Validation" expected="SuccessAndFailure" />
  <rule id="WIN-17.2.3" category="audit" field="User Account Management" expected="SuccessAndFailure" />
  <rule id="WIN-17.5.1" category="audit" field="Account Lockout" expected="Failure" />
  <rule id="WIN-17.5.4" category="audit" field="Logon" expected="SuccessAndFailure" />
</config>
```

* Chaque `<rule>` correspond à **une ligne du Benchmark CIS**.
* `category` permet au script de savoir quel **type de traitement** faire (mot de passe, lockout, compte, service, firewall, audit).
* `expected` contient la valeur à respecter.

---

## 6. Modes d’exécution du script (paramètres)

Le script `AzeezScriptWin.ps1` accepte les paramètres suivants, comme demandé dans l’énoncé du TP :

* `-f <fichier.xml>`  **(obligatoire)** (`config_windows.xml`).

* `-v`  (validation)

* `-c`  (correction)

* `-q`  (quiet)

* `-s <fichier_sortie>` (`resultat_windows.txt`).

* `-2`

---

## 7. Commandes pour faire le tests

À exécuter dans le dossier :

```
cd C:\Users\utilisateur\TP2_Windows
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
---
![Image 1](https://i.postimg.cc/fbn4k4wq/caadfs.png)
---

### 7.1. Validation simple (lecture seule)

```
.\AzeezScriptWin.ps1 -f .\config_windows.xml -v
```
* Vérifie tous les paramètres CIS.
* Affiche pour chaque règle : l’état actuel, la valeur attendue, et si c’est conforme ou non.
* **Aucune modification** n’est faite sur la machine.

### 7.2. Validation silencieuse (seulement les problèmes)

```
.\AzeezScriptWin.ps1 -f .\config_windows.xml -v -q
```
----
![Image 2](https://i.postimg.cc/g0vCZMJ4/Capture-d-e-cran-2025-12-08-201224-(1).png)
----


* N’affiche que :
  * les règles **non conformes**,
  * et les **warnings** éventuels.
* Pratique pour un admin qui veut voir rapidement « ce qui cloche ».

### 7.3. Validation + correction + log dans un fichier (admin)

Ouvrir **PowerShell en tant qu’administrateur**, puis :

```
cd C:\Users\utilisateur\TP2_Windows
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

.\AzeezScriptWin.ps1 -f .\config_windows.xml -c -2 -s resultat_windows.txt
```

* Le script :

  * Vérifie chaque règle CIS.
  * Corrige les paramètres non conformes (registre, `net accounts`, firewall, audit, compte Guest…).
  * Affiche les messages d’analyse à l’écran.
  * Écrit **les mêmes messages** dans `resultat_windows.txt`.

Pour consulter le fichier :

```
Get-Content .\resultat_windows.txt
```
---
![Image 4](https://i.postimg.cc/GpkWyM2q/Capture-d-e-cran-2025-12-08-201319.png)
---
---
### Bibliographie/Déclaration d’utilisation des références – CIS Windows 11
| Référence                                                             | Description                                                                                                                                                                                                                                                                                                                                                                                    | Lien                                                       |
| --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| **Notes de cours – TP2 Windows**                                      | Notes de cours de M. Lacasse sur PowerShell, la sécurité Windows 11 et l’énoncé du TP2 (paramètres `-f`, `-v`, `-c`, `-q`, `-s`, `-2`). Je m’en suis servi pour savoir comment structurer mon script et quels paramètres il fallait absolument gérer.                                                                                                                                          | N.A.                                                       |
| **Document “Configurer la sécurité – Points de références (CIS)”**    | PDF du prof qui explique ce que sont les benchmarks CIS, comment les lire (Description, Rationale, Impact, Audit, Remédiation) et comment les appliquer dans un vrai environnement. Ça m’a aidé à comprendre la logique derrière chaque règle Windows.                                                                                                                                         | N.A.                                                       |
| **CIS Benchmark – Microsoft Windows 11 Enterprise**                   | Référence principale pour les règles à implémenter : mot de passe (1.1.x), verrouillage de compte (1.2.x), comptes (2.3.1.x), service FTP (5.11), firewall (9.x), audit (17.x). Je m’en suis servi pour connaître les valeurs attendues (ex. longueur min = 14, lockout = 15 min, etc.).                                                                                                       | [https://www.cisecurity.org](https://www.cisecurity.org)   |
| **Documentation Microsoft – Paramètres de stratégie de mot de passe** | Page officielle qui explique `Enforce password history`, `Maximum password age`, `Minimum password age`, `Minimum password length`, `Password must meet complexity requirements`, etc. Utilisée pour vérifier que mes règles CIS sont bien alignées avec les options Windows.                                                                                                                  | [https://learn.microsoft.com](https://learn.microsoft.com) |
| **Documentation Microsoft – Stratégies de verrouillage de compte**    | Explications des paramètres de verrouillage : `Account lockout duration`, `Account lockout threshold`, `Reset account lockout counter after`. Je m’en suis servi pour comprendre comment ces valeurs agissent ensemble et quelle unité (minutes, tentatives…).                                                                                                                                 | [https://learn.microsoft.com](https://learn.microsoft.com) |
| **Documentation Microsoft – Local Security Policy / secpol.msc**      | Infos générales sur les stratégies locales Windows, notamment pour les comptes (Guest, mots de passe vides), les options de sécurité et l’audit. Ça m’a aidé à faire le lien entre les noms CIS et les noms des paramètres dans l’interface Windows.                                                                                                                                           | [https://learn.microsoft.com](https://learn.microsoft.com) |
| **Documentation Microsoft – Auditpol**                                | Documentation de la commande `auditpol.exe` pour configurer les catégories d’audit (Credential Validation, User Account Management, Account Lockout, Logon, etc.). Je m’en suis servi pour comprendre comment un script PowerShell peut appliquer les règles d’audit CIS 17.x.                                                                                                                 | [https://learn.microsoft.com](https://learn.microsoft.com) |
| **Documentation Microsoft – Windows Defender Firewall**               | Référence pour la configuration du firewall (Domain / Private / Public) via l’interface et/ou PowerShell. Utile pour vérifier le comportement attendu quand l’état du firewall est à `On (recommended)` dans les 3 profils.                                                                                                                                                                    | [https://learn.microsoft.com](https://learn.microsoft.com) |
| **Manpages PowerShell / Get-Help**                                    | Utilisation de `Get-Help` dans PowerShell (`Get-Help Get-ItemProperty`, `Get-Help Set-ItemProperty`, etc.) pour comprendre comment lire/écrire dans le registre et manipuler certains paramètres système.                                                                                                                                                                                      | Commandes locales (`Get-Help …`)                           |
| **ChatGPT**                                                           | Requête : *« Aide-moi à imaginer la structure d’un script PowerShell qui lit un XML et applique des règles CIS (password, lockout, firewall, audit) sur Windows 11 avec des options -f, -v, -c, -q, -s, -2. »* <br> Utilité : m’a aidé à organiser le script par catégories (password, lockout, account, service, firewall, audit) et à garder une logique simple pour un admin junior.        | [https://chat.openai.com](https://chat.openai.com)         |
| **ChatGPT**                                                           | Requête : *« Comment lire un fichier XML en PowerShell et boucler sur chaque `<rule>` avec des attributs (id, category, field, expected) ? »* <br> Utilité : m’a donné l’idée d’utiliser `[xml]` pour charger le fichier, puis de parcourir ` $xml.config.rule` et de dispatcher selon `category`.                                                                                             | [https://chat.openai.com](https://chat.openai.com)         |
| **ChatGPT**                                                           | Requête : *« Comment vérifier en PowerShell la politique de mot de passe (history, max age, min age, min length, complexity) d’une machine locale, sans utiliser de GPO domaine ? »* <br> Utilité : m’a donné des pistes (commande `net accounts`, registre `HKLM\SYSTEM\CurrentControlSet\Control\Lsa`…) pour comparer la valeur actuelle avec la valeur attendue dans le XML.                | [https://chat.openai.com](https://chat.openai.com)         |
| **ChatGPT**                                                           | Requête : *« Propose un exemple de messages d’affichage humains pour un script CIS Windows 11 (OK / NON CONFORME) qui seraient compréhensibles pour un admin junior. »* <br> Utilité : m’a aidé à formuler les sorties de façon claire, par exemple : `"[PASS][WIN-1.1.4] Longueur minimale = 14 (conforme, attendu 14)"` ou `"[ALERTE][WIN-9.1.1] Firewall domaine désactivé (attendu : On)`. | [https://chat.openai.com](https://chat.openai.com)         |
| **Stack Overflow / Forums techniques**                                | Lecture d’exemples pour : lire des clés de registre en PowerShell, vérifier l’état d’un service, manipuler le firewall avec `Set-NetFirewallProfile`, et traiter les erreurs avec `try/catch`. Je m’en suis servi pour rendre le script plus robuste (gestion des exceptions).                                                                                                                 | [https://stackoverflow.com](https://stackoverflow.com)     |
| **Notes personnelles**                                                | Notes prises en classe sur la différence entre L1 / L2 / NG, sur le comportement attendu, et sur la façon dont le prof va tester le script (clone de la VM, exécution avec différentes options, utilisation d’un script pour casser la config avant les tests).                                                                                                         | N.A.                                                       |
