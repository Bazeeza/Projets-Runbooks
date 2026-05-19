# Fiche de planification de la stratégie

## Objectif de Stratégie
Mon objectif ici est de décrire ma stratégie avant de commencer le projet sur **Asana**. J’explique la procédure de comment je vais découper le projet en plusieurs parties et comment je vais les réaliser pour arriver au but final avec un script fonctionnel.

---

## Schéma de planification

| Élément       | Contenu                                                                 |
|---------------|-------------------------------------------------------------------------|
| **Référent**  | Un script qui lit un fichier XML et crée des projets, sections et activités dans **Asana**. |
| **Émetteur**  | Moi-même, Abdul-Bariu.                                                  |
| **Message**   | Mon but est d’expliquer comment je vais organiser mon travail étape par étape pour réussir à produire un script fonctionnel. |
| **Récepteur** | M. Gilles Lacasse                                                       |
| **Canal**     | Un dépôt GitLab                                                         |
| **Code**      | La langue française écrite.                                             |

---

# Stratégie initiale – Développement du script Asana

## Stratégie 1 : Familiraisation avec l'appli ASANA
**Explication :** Ici je dois apprendre comment Asana fonctionne avant de coder. Si je comprends bien l’interface, ça sera plus facile d’écrire le script après.  

**Procédure :**
- Créer un compte gratuit sur **asana.com**.  
- Explorer l’interface : créer un projet test avec des sections et des tâches manuellement.  
- Observer les mots qu’Asana utilise (projet, section, tâche, vue en liste ou tableau).
- Consultation du forum Developers & API ---pour voir les requetes des autres utilisateur ou encore pour retrouve de l'information qui pourrait aider.  
- **Résultat attendu :** avoir un projet test dans mon compte Asana et bien comprendre comment tout est organisé.

---

## Stratégie 2 : Création d’un échéancier
**Explication :** Ici je dois me donner un horaire pour travailler. Ça va m’aider à avancer sans me perdre et à finir le projet dans les délais.  

**Procédure :**
- Faire un petit calendrier (par exemple dans Excel).  
- Indiquer mes heures de travail chaque semaine.  
- Mettre des objectifs clairs pour chaque bloc de temps (ex. semaine 1 → découverte et lecture XML, semaine 2 → création projet Asana, etc.).  
- **Résultat attendu :** un plan de temps simple pour respecter les remises.

---

## Stratégie 3 : Lecture et familiarisation avec le fichier XML
**Explication :** Ici je dois comprendre comment le fichier XML est construit. Si je le comprends bien, je pourrai mieux coder le script qui va le lire.  

**Procédure :**
- Ouvrir le fichier XML fourni par le prof dans VS Code.  
- Identifier les balises principales : `<projet>`, `<section>`, `<tache>`.  
- Vérifier si certaines valeurs sont “?” → je devrai demander ces infos à l’utilisateur.  
- Utiliser `xml.etree.ElementTree` (Python) pour lire le fichier et afficher les infos dans le terminal.  
- **Résultat attendu :** voir le contenu du XML affiché correctement dans le terminal.

---

## Stratégie 3.1 : Gestion des cas spéciaux
**Explication :** Ici je dois prévoir les situations spéciales pour éviter que le script fasse des doublons ou des erreurs.  

**Procédure :**
- Si le projet, la section ou la tâche existe déjà → réutiliser au lieu de recréer.  
- Si le XML contient “?” → demander à l’utilisateur d’entrer la valeur.  
- Supprimer la section par défaut qu’Asana ajoute automatiquement.  
- **Résultat attendu :** un projet propre, sans doublons.

---

## Stratégie 3.2 : Gestion des erreurs
**Explication :** Ici je dois m’assurer que le script ne plante pas si quelque chose va mal.  

**Procédure :**
- Si le XML est invalide → afficher un message clair.  
- Si l’API Asana ne répond pas → afficher un message d’erreur.  
- Si une tâche n’a pas de nom → demander à l’utilisateur d’en entrer un.  
- **Résultat attendu :** un script robuste qui explique les erreurs au lieu de s’arrêter.

---

## Stratégie 4 : Choix du langage de codage
**Explication :** Ici je dois choisir un langage adapté pour réussir à communiquer avec Asana et lire un fichier XML.  

**Procédure :**
- Trois langages possibles : **Python, Bash, PowerShell**.  
- Je choisis **Python** parce que :  
  - c’est facile à comprendre et lire,  
  - ça gère bien les fichiers XML,  
  - ça marche très bien avec des API (librairie `asana`).  
- Plan B : utiliser **PowerShell** si jamais Python ne marche pas (car il gère aussi bien XML et API sous Windows).  
- **Résultat attendu :** un langage adapté et efficace.

---

## Stratégie 5 : Consultation de documentation Asana
**Explication :** Ici je dois apprendre à utiliser l’API d’Asana pour créer un projet, des sections et des tâches.  

**Procédure :**
- Lire la documentation officielle d’Asana sur l’API.  
- Utiliser les exemples donnés pour voir comment créer un projet et ajouter des tâches.  
- M’inspirer de tutoriels trouvés en ligne (Medium, Reddit, StackOverflow).  
- **Résultat attendu :** savoir comment coder avec l’API pour créer un projet automatiquement.

---

## Stratégie 5.1 : Connexion à l’API Asana
**Explication :** Ici je dois prouver que mon script peut se connecter à mon compte Asana.  

**Procédure :**
- Générer un **token API** (PAT) dans mon compte Asana.  
- Installer la librairie Python `asana` avec `pip install asana`.  
- Écrire un mini-script test qui affiche mon nom d’utilisateur depuis l’API.  
- **Résultat attendu :** communication réussie entre mon script et Asana.

---

## Stratégie 5.2 : Ajout des sections et activités
**Explication :** Ici je dois transformer les infos du XML en vraies sections et tâches dans Asana.  

**Procédure :**
- Lire les balises `<section>` du XML et les créer dans Asana.  
- Lire les balises `<tache>` et les ajouter aux bonnes sections.  
- Si une tâche contient des sous-tâches, les créer aussi avec l’API.  
- **Résultat attendu :** toutes les sections et tâches du XML apparaissent dans Asana.

---

## Stratégie 6 : Documentation au fur et à mesure
**Explication :** Ici je dois écrire mes notes pour ne rien oublier et laisser une trace claire.  

**Procédure :**
- Ajouter des commentaires simples dans le script pour chaque étape.  
- Rédiger une petite documentation (Markdown ou PDF) :  
  - comment installer Python,  
  - comment lancer le script (`python script.py fichier.xml`),  
  - exemples de résultats.  
- **Résultat attendu :** tout le monde peut utiliser mon script facilement.

---

## Stratégie 7 : Tests et Captures d'écran
**Explication :** Ici je dois montrer que mon script marche vraiment.  

**Procédure :**
- Tester le script avec le fichier XML donné par le prof.  
- Vérifier que le projet, les sections et les tâches apparaissent dans Asana.  
- Faire des captures d’écran comme preuves pour l’évaluation.  
- **Résultat attendu :** preuves captures d'ecran du fonctionnement du script.

---

## Stratégie 8 : Plan B et sauvegardes ou encore BACKUP
**Explication :** Ici je dois prévoir un plan B si jamais l’API ne marche pas, pour éviter de repartir à zéro.  

**Procédure :**
- Faire des sauvegardes régulières de mon code sur gitlab pour pourvoir y revien tout comme un backup.  
- Si l’API échoue → au minimum, afficher dans le terminal ce que le script aurait créé dans Asana.  
- **Résultat attendu :** même en cas de problème, montrer que je comprends le traitement du XML.

---

# Bibliographie / Déclaration d’utilisation des références

| Référence       | Description                                                        | Lien         |
|-----------------|--------------------------------------------------------------------|--------------|
| **Notes de cours** | Méthode QQOQCCP votre notre de cours.                    | https://drive.google.com/file/d/1ZbJ2AunaODUzEc7zH3ylcvf_-0t21QJY/view?pli=1 |
| **Documentation Asana** | Consultation des Informations officielles sur l’API Asana ou encore le forum         | https://forum.asana.com/c/forum-en/api/24 |
| **Notes Perso** | Notes verbal transmise par vous lors du cours-1 | N.A |
| **ChatGPT**     | Ma requete est de lister une idée des exemples des stratégie qui sont important dans mon cardre du projet. | https://chat.openai.com |
| **ChatGPT**     | Ma requete ici est donne un exemple des résultats attendu par mon prof. (Vous pourrez consulter les requetes via le lien)    | https://chat.openai.com |

---
