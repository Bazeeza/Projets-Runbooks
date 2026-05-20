# Travail Pratique 1 – Création GLPI Agent (Ubuntu)

| Élément       | Contenu                                                                 |
|---------------|-------------------------------------------------------------------------|
| **Référent**  | Une presentation et documentation de la partie installation -- configuration du **GLPI** x **MySQL** hebergé sur un Serveur Ubuntu AWS |
| **Émetteur**  | **Abdul-Bariu. Abdul-Majid. Aran**                                                  |
| **Message**   | Notre but ici est de vous présenter et documenté nos résultats de notre installation |
| **Récepteur** | **M. Jérémy Massinon**                                                      |
| **Canal**     | Un dépôt GitLab                                                         |
| **Code**      | La langue française écrite.                                             |
| **Référence**      | Consultez la [Documentation GLPI](https://faq.teclib.com/fr/03_knowledgebase/procedures/install_glpi/)|

---

## Prérequis

- Une VM Client Linux (Ubuntu)
- Avoir un accès avec des privilèges sudo sur le système Ubuntu.
- GLPI Agent disponible pour téléchargement depuis le site officiel : [GLPI Agent Releases](https://github.com/glpi-project/glpi-agent/releases).
- Connaître l'URL du serveur GLPI où l'agent doit envoyer les informations d'inventaire.

---

## Étapes d'Installation

1. **Mettre à Jour les Paquets**

   Avant toute installation, assurez-vous que le système est à jour :

   ```
   sudo apt update && sudo apt upgrade -y
   ```

2. **Télécharger le Paquet GLPI Agent**

   Téléchargez le fichier `.deb` pour l'agent GLPI (remplacez `<version>` par le numéro de version désiré, par exemple `1.7-1`) :

   ```
   wget https://github.com/glpi-project/glpi-agent/releases/download/1.7/glpi-agent_1.7_all.deb
   ```

3. **Installer GLPI Agent**

   Installez le paquet téléchargé en utilisant `dpkg` :

   ```
   sudo dpkg -i glpi-agent_1.7_all.deb
   ```

   Si des erreurs de dépendances apparaissent, résolvez-les avec la commande :

   ```
   sudo apt --fix-broken install
   ```

4. **Configurer GLPI Agent**

   Ouvrez le fichier de configuration de GLPI Agent et ajoutez les informations de votre serveur GLPI :

   ```
   sudo nano /etc/glpi-agent/glpi-agent.conf
   ```

   Modifiez le fichier pour y inclure l’URL de votre serveur GLPI :

   ```ini
   [server]
   server = http://<adresse_du_serveur_glpi>/front/inventory.php
   ```

   Remplacez `<adresse_du_serveur_glpi>` par l'adresse de votre serveur GLPI.

5. **Vérifier l'Installation de GLPI Agent**

   Assurez-vous que GLPI Agent est bien installé et que le service est actif :

   ```
   sudo systemctl status glpi-agent
   ```

   Si le service n’est pas en cours d’exécution, démarrez-le :

   ```
   sudo systemctl start glpi-agent
   ```

6. **Lancer un Inventaire Manuel**

   Pour lancer un inventaire manuel et envoyer les données au serveur GLPI, exécutez la commande suivante :

   ```
   sudo glpi-agent --server http://<adresse_du_serveur_glpi>/front/inventory.php --debug
   ```

7. **Activer GLPI Agent au Démarrage**

   Pour que GLPI Agent démarre automatiquement au démarrage du système :

   ```
   sudo systemctl enable glpi-agent
   ```

---

## Vérification dans l'Interface GLPI

Après avoir lancé l'inventaire, connectez-vous à l'interface web de GLPI et allez dans **Inventaire > Ordinateurs** pour vérifier que la machine Ubuntu a bien été ajoutée.

---

En suivant ces étapes, GLPI Agent sera installé et configuré sur votre système Ubuntu, prêt à envoyer les informations d'inventaire à votre serveur GLPI.
   Pour lancer un inventaire manuel et envoyer les données au serveur GLPI, exécutez la commande suivante :

   ```
   sudo glpi-agent --server http://<adresse_du_serveur_glpi>/front/inventory.php --debug
   ```

7. **Activer GLPI Agent au Démarrage**

   Pour que GLPI Agent démarre automatiquement au démarrage du système :

   ```
   sudo systemctl enable glpi-agent
   ```
---

## Vérification dans l'Interface GLPI

Après avoir lancé l'inventaire, connectez-vous à l'interface web de GLPI et allez dans **Inventaire > Ordinateurs** pour vérifier que la machine Ubuntu a bien été ajoutée.

- Résultat de la machine inventoriée
---
![Screenshot-2025-09-30-at-11-19-59-PM](https://i.postimg.cc/hvsw231K/Screenshot-2025-09-30-at-11-19-59-PM.png)

---
- information d'inventaire 
---
![Screenshot-2025-09-30-at-11-20-22-PM](https://i.postimg.cc/90bSLNYD/Screenshot-2025-09-30-at-11-20-22-PM.png)
---