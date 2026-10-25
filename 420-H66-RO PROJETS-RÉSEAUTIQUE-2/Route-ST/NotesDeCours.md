# Notes de cours — Routage statique

**Routes statiques, route par défaut et routes flottantes sur Cisco IOS**

| Élément | Contenu |
|---|---|
| **Référent** | Le routage statique sur Cisco IOS : routes vers un réseau, route par défaut et route flottante de secours. |
| **Émetteur** | Bariu Azeez |
| **Message** | Résumer les notions de routage statique utilisées dans le projet de routage de secours. |
| **Récepteur** | M. Jérémy Massinon |
| **Canal** | Dépôt GitLab du cours (Collège de Rosemont), republié sur GitHub |
| **Code** | Français |
| **Référence** | [Cisco — Distance administrative](https://www.cisco.com/c/en/us/support/docs/ip/border-gateway-protocol-bgp/15986-admin-distance.html) |

---

## Documents du dossier

| Document | Contenu |
|---|---|
| [README du projet](README.md) | Routage de secours entre deux bâtiments : objectif, topologie, plan d'adressage, tests |
| [Configurations](Configurations.md) | Configuration complète de chaque équipement |

## Notions clés

| Notion | En bref |
|---|---|
| Route statique | `ip route <réseau> <masque> <prochain saut>` : le chemin est fixé à la main par l'administrateur. |
| Route par défaut | `ip route 0.0.0.0 0.0.0.0 <prochain saut>` : utilisée quand aucune route plus précise n'existe. |
| Distance administrative | Fiabilité d'une source de route ; la plus petite gagne (1 pour une route statique, 110 pour OSPF). |
| Route flottante | Route statique avec une distance plus grande : elle reste cachée et n'entre dans la table que si la route principale disparaît. |

> [!NOTE]
> Les notes rédigées de ce cours sont **à compléter**. Le projet détaillé se trouve dans le [README du projet](README.md).
