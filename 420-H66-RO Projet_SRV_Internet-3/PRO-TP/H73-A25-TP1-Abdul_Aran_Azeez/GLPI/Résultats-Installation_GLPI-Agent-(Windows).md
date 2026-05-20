# Inventaire Serveur et Client

| Élément       | Contenu                                                                 |
|---------------|-------------------------------------------------------------------------|
| **Référent**  | Une presentation et documentation de la partie installation -- configuration du **GLPI** x **MySQL** hebergé sur un Serveur Ubuntu AWS |
| **Émetteur**  | Abdul-Bariu. Abdul-Majid. Aran                                                  |
| **Message**   | Notre but ici est de vous présenter et documenté nos résultats de notre installation |
| **Récepteur** | **M. Jérémy Massinon**                                                      |
| **Canal**     | Un dépôt GitLab                                                         |
| **Code**      | La langue française écrite.                                             |
| **Référence**      | Consultez la [Documentation GLPI](https://glpi-agent.readthedocs.io/en/latest/installation/) ou encore [Numelion IT Tutoriels](https://www.youtube.com/watch?v=xmLPdNdPZ_k&t=316s) |

## Préparation de l'environnement de travail et Prérequis

Pour faire l'inventaire, vous devez :

- Installer et Configurer une **VM Client Windows** ou **Serveur Windows 2019**
- **Télécharger l'Agent GLPI** pour Windows :  
  Téléchargez la dernière version de l'agent ici : [Agent GLPI sur GitHub](https://github.com/glpi-project/glpi-agent/releases).

## Étape 2 : Installer l'Agent GLPI

Suivez les étapes d'installation de l'agent. Lisez et suivez les instructions affichées pendant l'installation.

## Étape 3 : Configurer l'Agent GLPI

Choisissez l'option **installation complète**.

---

![Screenshot-2025-09-30-at-1-43-40-AM](https://i.postimg.cc/JzrvFZ6J/Screenshot-2025-09-30-at-1-43-40-AM.png)


### Identifier le Serveur GLPI

Indiquez l'adresse (URL) de votre serveur GLPI. Cette adresse dépend de votre configuration.

---

![Screenshot-2025-09-30-at-1-45-04-AM](https://i.postimg.cc/4xfq0VLv/Screenshot-2025-09-30-at-1-45-04-AM.png)

---
## Étape 4 : Forcer un inventaire avec l'agent installé

1. Ouvrez le logiciel **Services** sur Windows.
2. Trouvez **glpi-agent** dans la liste (elle est classée par ordre alphabétique).
3. Cliquez avec le bouton droit, puis choisissez **Redémarrer**.

Ensuite, connectez-vous à GLPI, puis allez dans **Administration > Inventaire** et assurez-vous que l'option "Activer l'inventaire" est bien cochée.

![Screenshot-2025-09-30-at-1-46-35-AM](https://i.postimg.cc/FHr863WP/Screenshot-2025-09-30-at-1-46-35-AM.png)

Pour vérifier manuellement que l'agent fonctionne, connectez-vous avec l'une de ces adresses :

- `http://localhost:62354`
- `http://127.0.0.1:62354`

![Screenshot-2025-09-30-at-1-52-59-AM](https://i.postimg.cc/CxhX2kP3/Screenshot-2025-09-30-at-1-52-59-AM.png)
---


Une fois connecté, cliquez sur **Forcer l'inventaire** pour démarrer l'inventaire immédiatement.

## Étape 5 : Finaliser l'installation

Après l'installation, si l'inventaire a été fait, il apparaîtra dans l'onglet **Ordinateurs** de GLPI en quelques secondes.

![Screenshot-2025-09-30-at-1-53-58-AM](https://i.postimg.cc/4xWqRyqB/Screenshot-2025-09-30-at-1-53-58-AM.png)

----
![Screenshot-2025-09-30-at-1-55-59-AM](https://i.postimg.cc/ht26Rv66/Screenshot-2025-09-30-at-1-55-59-AM.png)

---
![Screenshot-2025-09-30-at-1-55-17-AM](https://i.postimg.cc/mgmJWkJ6/Screenshot-2025-09-30-at-1-55-17-AM.png)

---

