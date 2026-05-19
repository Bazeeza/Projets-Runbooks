# Réflexion sur la stratégie 1

**Schéma de planification**

| Élément       | Contenu                                                                 |
|---------------|-------------------------------------------------------------------------|
| **Référent**  | Un script qui lit un fichier XML et crée des projets, sections et activités dans **Asana**. |
| **Émetteur**  | Moi-même, Abdul-Bariu.                                                  |
| **Message**   | Mon but est d’expliquer et montre une réflexion en faissant une comparaison du stratégie du début est celle qui est enfin utilisée |
| **Récepteur** | M. Gilles Lacasse                                                       |
| **Canal**     | Un dépôt GitLab                                                         |
| **Code**      | La langue française écrite.                                             |
  
---

## 1. Familiarisation avec Asana
**Voici les principales différences entre ce que j’avais planifié et ce que j’ai appliqué pour avoir un script functionelle.**

**Voici ce qui est prévu :**  
Je pensais juste créer un compte Asana par la suite tester rapidement l’interface et passer directement à la programmation du script.

**Ce qui est fait :**  
- D'abord, j’ai passé beaucoup plus de temps à explorer l’application, plus precisement le docs de API développeurs.  
- Ensuite, j’ai essayé de comprendre en détail les types de vues (liste, tableau), la différence entre projet et section, et comment Asana envoie ses infos via son API.  
- En outre, faire un lecture plusieurs discussions sur le **forum des développeurs d’Asana**, car certaines fonctions comme `client.tasks.create_in_workspace()` n’étaient pas bien expliquées dans la documentation principale.  
**Différence :** j’ai compris qu’il faut vraiment maîtriser l’outil avant de vouloir le coder.

---

## 2. Lecture du fichier XML
**Voici ce qui est prévu :**  
Je croyais que lire un fichier XML avec Python serait rapide à faire et sans problème.

**Ce qui est fait :**  
- J’ai rencontré des erreurs de balises et de format.  
- J’ai dû ajouter plusieurs tests dans le code pour m’assurer que chaque balise comme `<projet>` ou `<tache>` existait avant de la lire.  
- J’ai aussi utilisé la librairie `xml.etree.ElementTree` pour lire le fichier, mais certaines données étaient mal affichées à cause des espaces et des retours à la ligne.  
**Différence :** j’ai appris que le XML semble simple, mais qu’il faut bien le apprendre ses avant de l’utiliser dans un script.

---

## 3. Connexion à l’API d’Asana

**Voici ce qui est prévu :**  
Je pensais que faire la connexion API serait une simple commande avec la librairie `asana` et que tout allait marcher tout de suite.

**Ce qui est fait :**  
En réalité, ça a pris beaucoup plus de temps.  
Certaines commandes trouvées en ligne ne fonctionnaient pas parce qu’elles venaient d’anciennes versions de l’API.  
Même avec l’aide de ChatGPT, certaines requêtes comme `client.projects.create()` ne passaient pas, car ChatGPT ne connaissait pas toutes les mises à jour de l’API.  
J’ai donc dû aller lire directement la **documentation officielle de l’API Asana** pour trouver des exemples concrets comme :
```
client.tasks.create_task({'workspace': '12345', 'name': 'Nouvelle tâche', 'projects': ['67890']})
```
## 4. Gestion des erreurs et des cas spéciaux

**Ce que j’avais prévu :**
- Je voulais juste ajouter quelques print() pour afficher les erreurs s’il y en avait.

**Ce qui est fait :**  
- J’ai ajouté des blocs try et except pour capturer les erreurs d’API et les erreurs de lecture de fichier XML.
- Par la suite aussi prévu des messages plus clairs pour que l’utilisateur sache ce qui ne marche pas.
Par exemple :
```
try:
    client.projects.create_project({'name': nom_projet})
except asana.error.InvalidRequestError:
    print("Erreur : le projet existe déjà ou le token est invalide.")
```

**Différence : Donc ici, j’ai réalisé qu’un script doit prévoir tous les problèmes possibles, pas juste les cas de basses.**


### 7. Plan B et sauvegardes

**Voici ce qui est prévu :**  
Faire une seule sauvegarde sur gitlab.

**Ce qui est fait :**  
J’ai utilisé mon repertoire de base sur ma machine donc pour sauvegarder chaque version du script.
- Ainsi, si une version marche pas ou autres, je pouvais revenir à la précédente sans tout recommencer.
- J’ai aussi prévu un mode de secours : si l’API ne répond pas, le script affiche au moins ce qu’il aurait créé.

**Différence : j’ai compris que faire des sauvegardes fréquentes évite de perdre des heures de travail.**