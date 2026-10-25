# Notes de cours — NAT et PAT

**Traduction d'adresses et de ports sur routeurs Cisco**

| Élément | Contenu |
|---|---|
| **Référent** | La traduction d'adresses réseau (NAT) et de ports (PAT) sur Cisco IOS, en version statique et dynamique. |
| **Émetteur** | Bariu Azeez |
| **Message** | Distinguer les quatre types de traduction d'adresses et savoir lequel utiliser. |
| **Récepteur** | M. Jérémy Massinon |
| **Canal** | Dépôt GitLab du cours (Collège de Rosemont), republié sur GitHub |
| **Code** | Français |
| **Référence** | [Cisco — Configure Network Address Translation](https://www.cisco.com/c/en/us/support/docs/ip/network-address-translation-nat/13772-12.html) |

---

## Définitions

- **NAT** (*Network Address Translation*) : traduction d'une adresse IP vers une autre adresse IP.
- **PAT** (*Port Address Translation*) : traduction d'une adresse IP **et d'un port** vers une autre adresse IP et un autre port.

## Statique ou dynamique

| Mode | Fonctionnement |
|---|---|
| Statique | Les attributs après traduction sont définis explicitement par l'administrateur (adresse IP pour un NAT, couple IP:port pour un PAT). |
| Dynamique | Les attributs après traduction sont choisis par le routeur au moment où il reçoit le paquet. |

En croisant ces termes, on obtient quatre combinaisons possibles :

| | Statique | Dynamique |
|---|---|---|
| **NAT** | NAT statique | NAT dynamique |
| **PAT** | PAT statique | PAT dynamique |

Voir aussi la [configuration du TP final](TPFINAL-config.md).
