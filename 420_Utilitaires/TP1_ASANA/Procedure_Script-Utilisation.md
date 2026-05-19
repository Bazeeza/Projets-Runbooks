# Guide TUTO d'utilisation du script ASANA (macOS)

**Schéma de planification**

| Élément       | Contenu                                                                 |
|---------------|-------------------------------------------------------------------------|
| **Référent**  | Un script qui lit un fichier XML et crée des projets/tâches/sous-tâches, sections et activités dans **Asana**. |
| **Émetteur**  | Moi-même, Abdul-Bariu.                                                  |
| **Message**   | Mon but ici est de documenter la procédure à suivre afin de tester mon SCRIPT pour un utilisateur. |
| **Récepteur** | M. Gilles Lacasse                                                       |
| **Canal**     | Un dépôt GitLab                                                         |
| **Code**      | La langue française écrite.                                             |

---
### Prérequis

1. **Un ordinateur** : Avec macOS (ou Windows, Linux). Le script est exécutable sur tous les systèmes.
2. **Un compte Asana** : Si vous n’en avez pas, allez sur https://app.asana.com/ et créez-en un gratuitement. Notez votre email et mot de passe.
3. **Un token Asana** : C’est comme une clé pour permettre au script d’accéder à votre compte Asana. Je vous explique comment l’obtenir plus loin.
4. **Un fichier XML testable** : C’est le fichier qui décrit votre projet. Par exemple, `P01_Deploiements.xml` ou `Test1_Projet.xml` que vous allez tester, mais testez un autre si vous en avez. Mettez-le dans le même dossier que le script.
5. **Choix de langage** : Python
6. **Python** : C’est le programme qui exécute le script. Si vous ne l’avez pas, je vous montre comment l’installer sur macOS.

## Installer Python sur macOS
**Pourquoi ce choix ?**
**Raison personnelle :** 
- Pour mon cours de programmation 1 et 2, c’est le langage principal appris, donc mon niveau de maîtrise est beaucoup plus avancé comparé aux autres choix.
- Facile à comprendre avec une syntaxe simple et lisible (un plus si vous parlez bien l’anglais), ce qui est mon cas.

**Raison professionnelle Asana :**
- Selon la doc API Asana, elle est utilisée pour générer des tâches, donc ici ça marche bien.
- Python avec Asana permet d’interagir avec des services externes, de récupérer des données et d’intégrer diverses fonctionnalités d’Asana.
- Utilisation sur une ligne de commande, que ce soit sur macOS, Windows ou Linux.

**Procédure d’installation :**
- Allez sur le site officiel : https://www.python.org/downloads/.
- Téléchargez la version la plus récente pour macOS (par exemple, Python 3.12).
- Double-cliquez sur le fichier téléchargé (`.pkg`) et suivez les instructions à l’écran. Assurez-vous que l’option "Add Python to PATH" est cochée (elle peut apparaître comme "Install for all users").
- Pour simplifier, installez Homebrew (un gestionnaire de paquets pour macOS) si ce n’est pas déjà fait :
  ```
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- Ensuite, installez Python via Homebrew pour être sûr d’avoir la dernière version :
  ```
  brew install python
  ```
- Vérifiez si Python est installé : Ouvrez le Terminal (recherchez "Terminal" dans Spotlight, ou Cmd + T). Tapez :
  ```
  python3 --version
  ```
  Si vous voyez "Python 3.12.3" ou similaire, tout est carré !

**Capture d’écran : Vérification de Python**
![Capture 1](https://i.postimg.cc/L8PDwhPK/Screenshot-2025-10-09-at-10-12-05-AM.png)

---

## Créer un token Asana

1. Allez sur https://app.asana.com/ et connectez-vous avec votre compte.
2. Cliquez sur votre photo en haut à droite, puis "Mon profil" > "Apps" > "Developer Console".
3. Cliquez sur "Create new token".
4. Donnez un nom au token (par exemple, "Mon script XML").
5. Copiez le token (il ressemble à `2/**********************/******************:*******************`).
6. Sauvegardez-le dans un fichier texte sécurisé. Ne le partagez pas !
---
![Capture 2test](https://i.postimg.cc/CK39fWVP/Screenshot-2025-10-09-at-10-47-08-AM.png)
---
## Installer les outils nécessaires

1. Ouvrez un terminal.
2. Tapez ces commandes une par une :
   ```
   pip install asana
   pip install python-dotenv
   ```
   - Si la commande `pip` n'est pas reconnu, utilisez ceci
   ```
   python -m pip install asana
   python -m pip install python-dotenv
   ```
3. Créez un fichier `.env` dans le dossier du script :
   - Ouvrez un éditeur de texte (Notepad sur Windows, TextEdit sur macOS).
   - Tapez :
     ```
     ASANA_PAT=votre_clée-token_ici
     ```
   - Sauvegardez le fichier sous le nom `.env` (avec le point devant) dans le même dossier que le script.
---
![Capture 4](https://i.postimg.cc/s2RmryPG/Screenshot-2025-10-09-at-10-21-40-AM.png)
---

## Préparer le fichier XML

1. Copiez le fichier XML (par exemple, `Pratique.xml`) dans le dossier du script.
2. Si vous avez un autre XML, assurez-vous qu'il a la structure correcte :
   - Commence par `<PROJET Nom="?" ...>`.
   - Contient `<SECTIONS>` avec `<SECTION Nom="?">`.
   - Tâches dans `<ACTIVITES>` avec `<NOM>`, `<DESCRIPTION>`, etc.

**Exemple de XML** :
```
<PROJET Nom="Déploiements Projet" Vue="Tableau" Description="Projet test">
    <SECTIONS>
        <SECTION Nom="Pratico-Pratique">
            <ACTIVITES>
                <ACTIVITE>
                    <NOM>Activité PP1</NOM>
                    <DESCRIPTION>Test PP1</DESCRIPTION>
                </ACTIVITE>
            </ACTIVITES>
        </SECTION>
    </SECTIONS>
</PROJET>
```
---

## Exécuter et lancer le script

Veuillez noter que le script Python se trouve dans le dossier TP1-Remise-Semaine-7 sur GitLab pour le télécharger.

1. Ouvrez le Terminal et allez dans le dossier du script :
   ```
   cd ~/Desktop/TP1-Asana
   ```
2. Créez un environnement virtuel (optionnel, mais recommandé pour éviter les conflits) :
   ```
   python3 -m venv venv
   source venv/bin/activate
   ```
3. Vérifiez que le cache Python ne cause pas de problèmes :
   ```
   rm -rf __pycache__ venv/lib/python3.12/site-packages/*/__pycache__
   ```
4. Tapez la commande pour lancer le script :
   ```
   python3 as_xml_tester.py --xml P01_Deploiements.xml --workspace 1211590922040040
   ```
   - Remplacez `P01_Deploiements.xml` par votre fichier XML (par exemple, `Test1_Projet.xml`).
   - Remplacez `1211590922040040` par votre GID de workspace. 
     - Pour trouver le GID : Allez dans Asana, cliquez sur votre workspace, regardez l’URL (comme `app.asana.com/0/1234567891223455/list` – le nombre `1234567891223455` est le GID).
5. Le script vous demande :
   - Nom du projet si `Nom="?"` (tapez un nom comme `Déploiements Projet`).
   - Nom de la section si `Nom="?"` (tapez un nom comme `Main Section`).
6. Le script crée le projet dans Asana. Vérifiez sur https://app.asana.com/.


## Exemple de commande complète

```
python3 as_xml_final.py --xml Pratique.xml --workspace 12345678532122040040
```

- Si vous avez le token dans `.env`, pas besoin de `--token`.
---
- Voici ici une capture sur l'execution du Pratique.xml 
---
![Capture 6](https://i.postimg.cc/fbjKWF5Y/Screenshot-2025-10-09-at-10-25-05-AM.png)
---
![Capture 7](https://i.postimg.cc/cJMm1jTF/Screenshot-2025-10-09-at-10-25-21-AM.png)
---

## Message Erreur Possible 

Donc ici, si jamais quelque ne va pas voici les message erreur donné:

- **Erreur "Fichier XML introuvable"** : Vérifiez que le fichier XML est dans le même dossier et que le nom est bien correct.
- **Erreur "Token invalide"** : Vérifiez votre token dans `.env` ou recréez-en un nouveau.
- **Erreur "Nom requis"** : Si vous appuyez sur Enter sans entrer un nom, le script s'arrête. Recommencez et entrez un nom.
- **Erreurs API** : Si Asana renvoie une erreur (par exemple, "403 Forbidden"), vérifiez votre token.

**Veuillez noter que si le script ne crée rien, relancez-le avec un nouveau token.**

## Comment vérifier le résultat

1. Allez sur https://app.asana.com/ et connectez-vous avec votre compte (par exemple, `barriuazeez@gmail.com`).
2. Cliquez sur votre workspace (par exemple, "My workspace").
3. Cherchez le projet (par exemple, `Déploiements Projet` ou `Test Déploiement`).
4. Vérifiez les sections (par exemple, `Pratico-Pratique`, `Main Section`).
5. Ouvrez les sections pour voir les tâches et sous-tâches.
6. Prenez des captures d’écran (`Cmd + Shift + 4` sur macOS) pour la soumission Moodle :
   - `Déploiements_Projet_Overview.jpg`, `Déploiements_Projet_Pratico.jpg`, `Déploiements_Projet_Main.jpg`.
   - `Test_Déploiement_Overview.jpg`.

**Captures d’écran : Résultat dans Asana**
![Capture 2](https://i.postimg.cc/hGqsBg8s/Screenshot-2025-10-09-at-10-19-33-AM.png)
![Capture 3](https://i.postimg.cc/QMrm3sgQ/Screenshot-2025-10-09-at-10-19-45-AM.png)
![Capture 5](https://i.postimg.cc/9FDzW7J3/Screenshot-2025-10-09-at-10-39-28-AM.png)
![Capture 8](https://i.postimg.cc/4NYnJ9Bg/Screenshot-2025-10-09-at-10-42-41-AM.png)

---

## Bibliographie / Déclaration d’utilisation des références

| Référence       | Description                                                        | Lien         |
|-----------------|--------------------------------------------------------------------|--------------|
| **Notes de cours** | Méthode QQOQCCP votre notre de cours.                    | https://drive.google.com/file/d/1ZbJ2AunaODUzEc7zH3ylcvf_-0t21QJY/view?pli=1 |
| **Documentation Asana** | Consultation des Informations officielles sur l’API Asana ou encore le forum         | https://forum.asana.com/c/forum-en/api/24 |
| **Notes Perso** | Notes verbal transmise par vous lors du cours-1 | N.A |
| **ChatGPT**     | Ma requete est de lister une idée des exemples des stratégie qui sont important dans mon cardre du projet. | https://chat.openai.com |
| **ChatGPT**     | Ma requete ici est donne un exemple des résultats attendu par mon prof. (Vous pourrez consulter les requetes via le lien)    | https://chat.openai.com |
| **Grok (xAI)**      | Requête : "Propose une stratégie pour créer un script Python qui lit un fichier XML et importe un projet dans Asana via l’API." <br> *Utilité* : Grok m’a aidé à planifier le script, en suggérant de parser le XML avec `xml.etree.ElementTree` et d’utiliser la bibliothèque `asana` pour l’API. | https://grok.x.ai |
| **Grok (xAI)**      | Requête : "Comment écrire une fonction Python pour vérifier si une tâche existe déjà dans une section Asana pour éviter les doublons ?" <br> *Utilité* : Grok m’a proposé un exemple de fonction `get_task_names_in_section` qui utilise les requêtes API `get_tasks` avec les paramètres `section` et `project` pour lister les tâches existantes. | https://grok.x.ai |
| **Grok (xAI)**      | Requête : "Donne un exemple de code pour demander un nom de projet à l’utilisateur quand Nom='?' dans un fichier XML." <br> *Utilité* : Grok m’a fourni un exemple avec `input()` pour gérer les cas où `Nom="?"` dans `<PROJET>` ou `<SECTION>`, ce qui a permis d’ajouter des prompts interactifs. | https://grok.x.ai |
| **Grok (xAI)**      | Requête : "Comment gérer les erreurs d’API Asana, comme les erreurs 403 ou 429, dans un script Python ?" <br> *Utilité* : Grok m’a conseillé d’utiliser `try/except` pour capturer les `ApiException` et d’augmenter les délais d’attente avec `_request_timeout=(15, 45)`. | https://grok.x.ai |
| **Grok (xAI)**      | Requête : "Rédige une documentation simple en Markdown pour un script Python qui importe un projet Asana, adaptée à un débutant." <br> *Utilité* : Grok m’a fourni un modèle de documentation claire avec des étapes A à Z, que j’ai adapté pour `Documentation_Utilisation_as_xml_final.md`. | https://grok.x.ai |
| **Grok (xAI)**      | Requête : "Pourquoi mon script crée des doublons de tâches dans Asana ? Propose une solution avec l’API." <br> *Utilité* : Grok a analysé le problème et suggéré de vérifier les tâches existantes avec une requête API basée sur la section, ce qui a conduit à améliorer `get_task_names_in_section`. | https://grok.x.ai |
| **Grok (xAI)**      | Requête : "Comment parser un fichier XML avec des sous-tâches imbriquées pour créer des tâches Asana ?" <br> *Utilité* : Grok m’a montré comment utiliser une fonction récursive comme `extract_activity` pour gérer les sous-tâches imbriquées dans `Pratique.xml`. | https://grok.x.ai |
| **Grok (xAI)**      | Requête : "Donne un exemple de résultats attendus pour un script qui importe un projet Asana depuis un XML." <br> *Utilité* : Grok m’a donné un exemple de sortie console (par exemple, `[INFO] Tâche créée: Activité PP1`) et une description du projet dans Asana, ce qui m’a aidé à vérifier les attentes du professeur. | https://grok.x.ai |

---

## Progression Script  — Captures d’écran + Requête captures d'écran résultat émis par GROK

## Capture 1
![Capture 1](https://i.postimg.cc/L8PDwhPK/Screenshot-2025-10-09-at-10-12-05-AM.png)

## Capture 2
![Capture 2](https://i.postimg.cc/hGqsBg8s/Screenshot-2025-10-09-at-10-19-33-AM.png)

## Capture 3
![Capture 3](https://i.postimg.cc/QMrm3sgQ/Screenshot-2025-10-09-at-10-19-45-AM.png)

## Capture 4
![Capture 4](https://i.postimg.cc/PrCNtwK4/Screenshot-2025-10-09-at-10-38-57-AM.png)

## Capture 5
![Capture 5](https://i.postimg.cc/9FDzW7J3/Screenshot-2025-10-09-at-10-39-28-AM.png)

## Capture 6
![Capture 6](https://i.postimg.cc/sDM1VhwR/Screenshot-2025-10-09-at-10-42-00-AM.png)

## Capture 7
![Capture 7](https://i.postimg.cc/ZKW0TdVJ/Screenshot-2025-10-09-at-10-42-21-AM.png)

## Capture 8
![Capture 8](https://i.postimg.cc/4NYnJ9Bg/Screenshot-2025-10-09-at-10-42-41-AM.png)
## Capture 9
![Capture 9](https://i.postimg.cc/tTk6Zn1m/Screenshot-2025-10-09-at-11-24-08-AM.png)

## Capture 10
![Capture 10](https://i.postimg.cc/7hL2gP79/Screenshot-2025-10-09-at-11-24-18-AM.png)

## Capture 11
![Capture 11](https://i.postimg.cc/Y0SW12gX/Screenshot-2025-10-09-at-11-24-32-AM.png)

## Capture 12
![Capture 12](https://i.postimg.cc/Rh0HcCfG/Screenshot-2025-10-09-at-11-24-39-AM.png)

## Capture 13
![Capture 13](https://i.postimg.cc/brvtQYbm/Screenshot-2025-10-09-at-11-25-08-AM.png)
