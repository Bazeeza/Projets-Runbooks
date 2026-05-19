# Travail Pratique 2.2 – AWS CloudWatch + Jellyfin
**Auteur But et Schéma planification**

| Élément        | Contenu                                                                 |
|----------------|-------------------------------------------------------------------------|
| **Référent**   | Présentation et documentation d’un serveur Jellyfin hébergé sur AWS sécurisé avec HTTPS, et supervisé via AWS CloudWatch. |
| **Émetteur**   | **Abdul-Bariu. Abdul-Majid. Aran**                                      |
| **Message**    | Présenter et documenter les résultats complets de l’installation et du déploiement de Jellyfin avec sa supervision CloudWatch sur AWS. |
| **Récepteur**  | M. Jérémy Massinon                                                  |
| **Canal**      | Un dépôt GitLab-Rosemont                                                         |
| **Code**       | La langue française                                                     |
| **Référence**  | Consultez la [Documentation officielle AWS EC2](https://docs.aws.amazon.com/fr_fr/ec2/) et [Jellyfin Docs](https://jellyfin.org/docs/). |

---
### Déploiement et configuration du serveur Jellyfin
**Explication**
Le service **Jellyfin** a été configuré et déployé sur le port **8096**.  
Donc, ici elle s’agit d’une serveur multimédia qui permettant de diffuser des fichiers vidéo, musique et tout autres contenus.  

**Après le déploiement :**
- L’interface Jellyfin est accessible via l’adresse publique.  
- La lecture d’un fichier média (musique/vidéo) est fonctionnel.  
- L’ajout de dossiers multimédias est possible depuis l’interface d’administration.
---
- Capture pour vérifier le statut du service :
---
![Cap 0](https://i.postimg.cc/XqjSYZr1/Screenshot-2025-10-21-at-8-19-27-PM.png)
---
- Cature résultat - Interface Web Jellyfin
---
![Screenshot 2](https://i.postimg.cc/VstTW2M6/Screenshot-2025-10-21-at-11-46-54-PM.png)
---
- Cature résultat lecture d’un média sur Jellyfin
---
![Screenshot 4](https://i.postimg.cc/x8L4jbnS/Screenshot-2025-10-21-at-11-50-47-PM.png)
---


### Nom domaine et HTTPS

Nous avons liée un **nom de domaine dynamique** via **No-IP** afin d’accéder à notre service Jellyfin sans utiliser l’adresse IP.  

| Élément | Détail |
|----------|--------|
| **Fournisseur** | No-IP |
| **Compte** | xy@lorkex.com |
| **Nom de domaine configuré** | azeezjellyfinaws.ddns.net |
| **Statut DNS** | Actif et fonctionnel |

**Pourquoi ?**
- Car ce choix nous permet de conserver un accès stable même en cas de changement d’adresse IP publique sur AWS.  
---
- Résultat - Capture du tableau No-IP
--- 
![Screenshot 1](https://i.postimg.cc/Fz0BFJmC/Screenshot-2025-10-21-at-11-45-34-PM.png)
---

### HTTPS avec Certbot

- Le HTTPS est configuré via **Certbot** (Let's Encrypt).  
- Une fois le certificat généré, le site est maintenat accessible en **https://azeezjellyfinaws** avec un **certificat SSL valide**.  
---
---
![Screenshot 3](https://i.postimg.cc/d3GxQTvb/Screenshot-2025-10-21-at-11-49-55-PM.png)
---
![Screenshot 2](https://i.postimg.cc/VstTW2M6/Screenshot-2025-10-21-at-11-46-54-PM.png)
---

### Supervision AWS CloudWatch

- AWS CloudWatch est un service de surveillance qui a un but premier de surveiller la performance d'un serveur afin de optimiser l'utilisation ses ressources. 
- Un tableau de bord avec plusieurs **métriques** pour évaluer la santé du système et du service Jellyfin.

**Métriques surveillées :**
1. **CPU Utilization (performance EC2)**  
2. **Utilisation du disque**  
3. **Band passante réseau (Network In/Out)**  
4. **Tentative de connexions échouées à Jellyfin**  
5. **Metrique personnalisée (au choix user)**  
---
- Résultat - Capture du tableau de bord CloudWatch
---
![Image 3](https://i.postimg.cc/SQLB5GnJ/IMG-3681.png)
---
- Résultat - Détails d’une alerte configurée
---
![Image 2](https://i.postimg.cc/Y2N5Vxv4/IMG-3680.png)
---
- Résultat liste de toutes les alamres actives
---
![Image 1](https://i.postimg.cc/6qhFvBk2/IMG-3679.png)
---
