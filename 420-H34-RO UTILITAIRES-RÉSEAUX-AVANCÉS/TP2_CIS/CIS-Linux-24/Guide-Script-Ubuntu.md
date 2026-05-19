# Guide TUTO d'utilisation du script CIS Bench Ubuntu 24.04 (AzeezScriptLinux.sh)

## Schéma de planification

| Élément       | Contenu                                                                                                                                                                              |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Référent**  | Un script Bash qui lit un fichier XML et vérifie / corrige des règles CIS Benchmark pour **Ubuntu Desktop 24.04** (packages, sysctl, services, comptes, journald, fichiers système). |
| **Émetteur**  | Moi-même.                                                                                                                                                                     |
| **Message**   | Expliquer clairement comment préparer, lancer et tester mon script de sécurisation CIS pour Ubuntu.                                                                                  |
| **Récepteur** | M. Gilles Lacasse                                                                                                                                                                    |
| **Canal**     | Dépôt GitLab : `azeez-420_utilitaires-2/TP2_CIS_Linux`                                                                             |
| **Code**      | Langue française écrite.                                                                                                                                                             |

---

## 1. Prérequis

1. **Une machine Ubuntu Desktop 24.04**
   * Le script est prévu pour la VM Ubuntu utilisée au labo **E-305**, mais fonctionnera aussi sur une autre Ubuntu 24.04.

2. **Droits sudo (pour la correction)**
   * Pour **valider uniquement** (`-v`), tu peux l’exécuter avec un utilisateur normal.
   * Pour **corriger** (`-c`) les paramètres (paquets, `/etc`, `sysctl`, journald, etc.), il faut utiliser `sudo`.

3. **Script et fichier XML présents dans le même dossier**

   * Sur la VM, les fichiers doivent se trouver dans (par exemple) :
     ```
     ~/TP2_Linux/
     ```
   * Fichiers minimum attendus :

     * `AzeezScriptLinux.sh` : script Bash principal
     * `config_linux.xml` : fichier XML avec les règles CIS Ubuntu

4. **Droit d’exécution sur le script**

   Si nécessaire, donner le droit d’exécution au script :

   ```
   mkdir TP2_Linux
   cd ~/TP2_Linux
   chmod +x AzeezScriptLinux.sh
   ```
---

## 2. Paramètres CIS Ubuntu gérés par le script

Le fichier `config_linux.xml` regroupe les règles demandées dans l’énoncé pour **Ubuntu Desktop 24.04** :

* **Packages / clients réseau**

  * 2.2.4 – Telnet client non installé
  * 2.2.6 – FTP client non installé

* **Réseau / noyau**
  * 3.3.1 – `ip_forwarding` désactivé

* **Pare-feu / UFW**

  * 4.1.1 – Une seule utilité de firewall active
  * 4.2.1 – `ufw` installé
  * 4.2.3 – `ufw` activé

* **Politiques de mot de passe**

  * 5.4.1.1 – Expiration des mots de passe configurée (`PASS_MAX_DAYS`)
  * 5.4.1.3 – Jours d’avertissement avant expiration (`PASS_WARN_AGE`)
  * 5.4.1.4 – Algorithme de hachage fort (yescrypt) dans PAM
  * 5.4.1.5 – `INACTIVE` configuré dans `/etc/default/useradd`
  * 5.4.1.6 – Date de dernier changement de mot de passe dans le passé pour tous les utilisateurs

* **Comptes système / root**

  * 5.4.2.1 – `root` est le seul compte avec UID 0
  * 5.4.2.2 – `root` est le seul compte avec GID 0
  * 5.4.2.4 – Accès root contrôlé (ex. `PermitRootLogin no` dans `sshd_config`)
  * 5.4.2.7 – Comptes système sans shell de login interactif

* **Timeout shell**

  * 5.4.3.2 – `TMOUT` défini pour le shell par défaut (inactivité max)

* **Journalisation / logs**

  * 6.1.1.1 – `systemd-journald` activé et en marche
  * 6.1.1.4 – Un seul système de logs en utilisation (ex. rsyslog ou syslog-ng)

* **Permissions fichiers sensibles**

  * 7.1.1 – Permissions sur `/etc/passwd` correctes

Votre script `AzeezScriptLinux.sh` utilise ces règles pour **comparer** l’état du système et éventuellement **corriger**.

---

## 3. Pourquoi Bash pour ce projet Ubuntu ?
### Raison pédagogique (cours 420-H34-RO)

* Le cours **utilitaires réseaux 1** couvre une partie de commande Linux et les scripts Bash faites.
* Bash est le langage util sur Ubuntu pour automatiser :

  * l’installation / suppression de paquets (`apt`),
  * les vérifications de fichiers (`ls`, `stat`, etc.),
  * la lecture / écriture de fichiers de configuration (`/etc/*`).

### Raison professionnelle (CIS & administration Linux)

* Les benchmarks CIS pour Linux utilisent des commandes système standard (apt, systemctl, sysctl, chmod, chown, etc.).

* Un script Bash :
  * est facilement exécutable via `./script.sh`,
  * peut être relancé par des admins juniors sans modifier le code,
  * fonctionne sur de nombreuses distributions (Debian/Ubuntu).

* Dans la vraie vie, ce type de script est utilisé pour :

  * **standardiser** la configuration de la sécurité sur un parc de serveurs Linux ;
  * **vérifier régulièrement** la conformité aux standards (comme CIS) ;
  * **corriger rapidement** après une dérive (mise à jour, intervention manuelle, etc.).

---

## 4. Structure du projet Linux (TP2_CIS_Linux)

Dans le dépôt GitLab `azeez-420_utilitaires-2/TP2_CIS_Linux` (ou dans `~/TP2_Linux` sur la VM), on retrouve :

```
TP2_Linux/
 ├─ AzeezScriptLinux.sh 
 ├─ config_linux.xml        
 └─ resultat_linux.txt
```

* Le script lit `config_linux.xml` pour savoir **quelles vérifications** faire.
* Le XML peut évoluer sans toucher au code (ajout/modif de règles).

---

## 5. Préparer l’environnement sur Ubuntu 24.04

### 5.1. Se placer dans le bon dossier

Sur la VM Ubuntu :

```
mkdir -p TP2_Linux
cd ~/TP2_Linux
ls
```
---
![Image 1](https://i.postimg.cc/hjx9pCvY/Capture-d-e-cran-du-2025-12-08-19-39-40.png)
---
---
Attendu au minimum :

```
AzeezScriptLinux.sh
config_linux.xml
```

### 5.2. Rendre le script exécutable (une seule fois)

Si ce n’est pas déjà fait :

```
chmod +x AzeezScriptLinux.sh
```

---

## 6. Modes d’exécution du script (paramètres)

Le script `AzeezScriptLinux.sh` accepte les mêmes paramètres logiques que la partie Windows du TP :

* `-f <fichier.xml>`  **(obligatoire)**
  → `config_linux.xml`

* `-v` (validation) = Vérifie la conformité sans modifier le système.

* `-c` (correction) = Vérifie **et corrige** les paramètres non conformes (nécessite `sudo`).

* `-q` (quiet) = N’affiche que les problèmes et/ou corrections (les règles déjà OK sont cachées).

* `-s <fichier_sortie>` =Sauvegarde le rapport dans un fichier texte (ex : `resultat_linux.txt`).

* `-2` = À utiliser **avec `-s`** :

  * affiche les messages à l’écran,
  * et écrit les mêmes messages dans le fichier.

> Si `-2` est utilisé sans `-s`, le script affiche un message d’erreur (comme demandé dans l’énoncé).

---

## 7. Commandes pour exécuter les tests

On suppose que vous êtes déjà dans le dossier :

```
cd ~/TP2_Linux
```

### 7.1. Validation simple (lecture seule, sans sudo)

```
./AzeezScriptLinux.sh -f config_linux.xml -v
```
---
![Image 3](https://i.postimg.cc/PxZm26Nq/Capture-d-e-cran-du-2025-12-08-19-50-17.png)
---
* Le script analyse :

  * présence/absence des paquets telnet / ftp,
  * valeur de `net.ipv4.ip_forward`,
  * état d’`ufw`,
  * paramètres de `/etc/login.defs`, `/etc/default/useradd`,
  * PAM yescrypt,
  * comptes système / root,
  * `TMOUT` dans `/etc/profile`,
  * état de `systemd-journald`,
  * système de logs,
  * permissions de `/etc/passwd`.
* Chaque règle affiche un message **OK** ou **non conforme**.
* Aucune modification n’est faite sur le système.

---

### 7.2. Validation silencieuse (seulement les problèmes)

```
./AzeezScriptLinux.sh -f config_linux.xml -v -q
```

* Seules les règles **non conformes** ou qui posent problème sont affichées.
* Utile pour un administrateur qui veut un résumé rapide de ce qui doit être corrigé.

---

### 7.3. Validation + correction + sortie dans un fichier

Il faut utiliser `sudo` :

```
sudo ./AzeezScriptLinux.sh -f config_linux.xml -c -2 -s resultat_linux.txt
cat resultat_linux.txt
```
---
![Image 4](https://i.postimg.cc/pT8Dq0yW/Capture-d-e-cran-du-2025-12-08-19-52-51.png)
---
![Image 5](https://i.postimg.cc/Ss8WDZjy/Capture-d-e-cran-du-2025-12-08-19-53-29.png)
---


### Bibliographie/Déclaration d’utilisation des références – CIS Bench Ubuntu 24.04
| Référence                                                          | Description                                                                                                                                                                                                                                                                                                                                | Lien                                                                                                     |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------- |
| **Notes de cours – TP2 Linux**                                     | Notes de cours du prof sur les scripts Bash, la sécurité Linux et l’énoncé du TP2 (paramètres `-f`, `-v`, `-c`, `-q`, `-s`, `-2`). Je m’en suis servi pour comprendre ce que le script devait absolument faire.                                                                                                                            | N.A.                                                                                                     |
| **Document “Configurer la sécurité – Points de références (CIS)”** | PDF donné par M. Lacasse qui explique ce que sont les benchmarks CIS, comment les trouver, comment lire chaque paramètre (description, impact, audit, remediation…). Je m’en suis servi pour comprendre la logique derrière chaque règle.                                                                                                  | N.A.                                                                                                     |
| **CIS Benchmark – Ubuntu Linux 24.04 LTS**                         | Référence principale pour choisir les paramètres obligatoires (2.2.4, 2.2.6, 3.3.1, 4.x, 5.x, 6.x, 7.1.1). Je l’ai utilisé pour savoir la valeur attendue (par exemple, ip_forward = 0, ufw actif, TMOUT, etc.).                                                                                                                           | [https://www.cisecurity.org](https://www.cisecurity.org)                                                 |
| **Documentation Ubuntu – UFW**                                     | Explications officielles sur comment activer / vérifier UFW (`ufw status`, `ufw enable`). Utile pour coder la partie du script qui vérifie si le pare-feu est installé et actif.                                                                                                                                                           | [https://ubuntu.com/server/docs/security-firewall](https://ubuntu.com/server/docs/security-firewall)     |
| **Documentation Ubuntu – systemd / journald**                      | Documentation qui décrit `systemd-journald`, comment voir son statut (`systemctl status systemd-journald`). Je m’en suis servi pour la règle CIS sur le service de journalisation.                                                                                                                                                         | [https://www.freedesktop.org/wiki/Software/systemd/](https://www.freedesktop.org/wiki/Software/systemd/) |
| **Manpages Linux (man, dpkg, sysctl)**                             | Utilisation de `man dpkg`, `man sysctl`, `man passwd`, etc., pour comprendre les commandes que j’utilise dans le script (par exemple vérifier les paquets, lire les paramètres noyau).                                                                                                                                                     | Commandes locales (`man dpkg`, `man sysctl`)                                                             |
| **ChatGPT**                                                        | Requête : *« Aide-moi à structurer un script Bash CIS Ubuntu avec des options -f, -v, -c, -q, -s, -2 qui lit un fichier XML et affiche les résultats clairement. »* <br> Utilité : m’a aidé à organiser le script par fonctions (affichage, validation, correction) et à garder un style d’output simple pour un admin junior.             | [https://chat.openai.com](https://chat.openai.com)                                                       |
| **ChatGPT**                                                        | Requête : *« Comment vérifier proprement dans un script Bash si un paquet (telnet ou ftp) est installé, puis l’indiquer comme conforme / non conforme ? »* <br> Utilité : m’a donné l’idée d’utiliser `dpkg -l` avec un test sur le code retour pour écrire les messages comme `[PKG][CIS-2.2.4-TELNET] 'telnet' non installé (conforme).` | [https://chat.openai.com](https://chat.openai.com)                                                       |
| **ChatGPT**                                                        | Requête : *« Donne-moi un exemple de test pour net.ipv4.ip_forward dans un script CIS Ubuntu (lecture avec sysctl + comparaison avec la valeur attendue). »* <br> Utilité : m’a aidé à construire la logique : récupérer la valeur avec `sysctl`, comparer à `0`, puis afficher un message clair et humain si c’est bon ou non.            | [https://chat.openai.com](https://chat.openai.com)                                                       |
| **ChatGPT**                                                        | Requête : *« Comment écrire en Bash un mode ‘quiet’ (-q) qui affiche seulement les règles non conformes, sans perdre les autres messages pour le fichier de sortie ? »* <br> Utilité : m’a permis de séparer la fonction d’ajout de lignes dans une variable (pour `-s`) et l’affichage conditionnel à l’écran selon la conformité.        | [https://chat.openai.com](https://chat.openai.com)                                                       |
| **ChatGPT**                                                        | Requête : *« Aide-moi à faire un gide qui doit tester le script en labo. »* <br> Utilité : m’a donné une structure de documentation (prérequis, commandes de test, messages d’erreur possibles) que j’ai adaptée à mon TP.                  | [https://chat.openai.com](https://chat.openai.com)                                                       |
| **Stack Overflow / Ask Ubuntu**                                    | Lecture de réponses sur : comment vérifier les permissions d’un fichier (`stat`), comment manipuler `/etc/login.defs`, `/etc/default/useradd`, et comment gérer proprement `sudo` dans un script. Je m’en suis servi comme complément aux notes de cours.                                                                                  | [https://askubuntu.com](https://askubuntu.com) / [https://stackoverflow.com](https://stackoverflow.com)  |
| **Notes personnelles**                                             | Petites notes prises en classe (explications orales du prof sur les critere, sur pourquoi on ne corrige pas certaines choses automatiquement comme les firewalls multiples) et tests que j’ai faits dans la VM (captures d’écran, commandes de validation).                                                                                        | N.A.                                                                                                     |

