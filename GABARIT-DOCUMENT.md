# Gabarit des documents

[← Retour à l'accueil du dépôt](README.md)

Tous les documents principaux du dépôt (notes de cours, guides d'installation, résultats de travaux pratiques, README de projet) commencent par le même en-tête. Il reprend le **schéma de la communication** (référent, émetteur, message, récepteur, canal, code) et ajoute une ligne **Référence** vers la documentation officielle utilisée.

Les fichiers de configuration brute (exercices Cisco, `PREP-*`) et les index de dossiers (`README.md` de cours) n'ont pas d'en-tête : ce sont des annexes ou des pages de navigation.

## En-tête standard

```markdown
# Titre du document

**Sous-titre en une phrase**

| Élément | Contenu |
|---|---|
| **Référent** | Le sujet technique traité (service, protocole, équipement). |
| **Émetteur** | Bariu Azeez (et les coéquipiers, s'il s'agit d'un travail d'équipe) |
| **Message** | Ce que le document permet de faire ou de comprendre. |
| **Récepteur** | À qui il s'adresse (enseignant, technicien, grand public). |
| **Canal** | Où il a été remis ou publié. |
| **Code** | Français |
| **Référence** | Liens vers la documentation officielle utilisée. |

---
```

## Règles

| Champ | Règle |
|---|---|
| **Titre** | Un seul titre de niveau 1 (`#`), sans point final ni numéro de version. Forme « Travail pratique N — Sujet » pour les travaux pratiques, « Notes de cours — Sujet » pour les notes. |
| **Sous-titre** | Facultatif : une phrase en gras qui précise le contexte (jamais « Auteur, but et schéma de planification »). |
| **Référent** | Décrit le contenu **réel** du document, jamais celui d'un autre travail copié. |
| **Émetteur** | Nom public **Bariu Azeez** ; les coéquipiers sont gardés, séparés par des virgules. |
| **Code** | Toujours « Français » (le dépôt `Technical-Runbooks` contient la version anglaise des procédures générales). |
| **Référence** | Documentation de l'éditeur (Cisco, AWS, Zabbix, GLPI…) de préférence à un tutoriel vidéo. |
| **Schéma** | Toute architecture décrite en texte (serveurs, sous-réseaux, flux) est accompagnée d'un schéma Mermaid. |

## Schémas Mermaid

GitHub affiche directement les blocs ` ```mermaid `. Pour qu'ils s'affichent sans erreur :

- mettre entre guillemets toute étiquette qui contient des parenthèses, des barres obliques ou des deux-points : `A["EC2 (Ubuntu)"]` ;
- ne pas commencer une étiquette par « 1. » (Mermaid la lit comme une liste) ;
- ne jamais y écrire d'adresse IP publique, de nom d'hôte réel ni de domaine privé.

> [!NOTE]
> Les adresses qui apparaissent dans les schémas sont celles des laboratoires (plages privées RFC 1918 ou blocs CIDR de VPC de cours).
