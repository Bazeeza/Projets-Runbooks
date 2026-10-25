# Notes de cours — Listes de contrôle d'accès (ACL)

**Filtrage du trafic entre VLAN sur routeurs Cisco**

| Élément | Contenu |
|---|---|
| **Référent** | Les listes de contrôle d'accès standard et étendues de Cisco IOS, appliquées pour filtrer le trafic entre VLAN et l'accès SSH aux équipements. |
| **Émetteur** | Bariu Azeez |
| **Message** | Regrouper les notions ACL travaillées en classe et renvoyer aux exercices où elles sont configurées. |
| **Récepteur** | M. Jérémy Massinon |
| **Canal** | Dépôt GitLab du cours (Collège de Rosemont), republié sur GitHub |
| **Code** | Français |
| **Référence** | [Cisco — Configure IP Access Lists](https://www.cisco.com/c/en/us/support/docs/security/ios-firewall/23602-confaccesslists.html) |

---

## Documents du dossier

| Document | Contenu |
|---|---|
| [Exercice 2025-04-07](<Exercice-ACL (2025-04-07).md>) | Règles d'accès par VLAN vers les serveurs web et FTP du site A (par nom de domaine), avec comptage des correspondances |
| [Exercice 2026-04-07](<Exercice-ACL (2026-04-07).md>) | Six VLAN de postes, règles PING et accès aux serveurs, SSH réservé au VLAN 40 (Telnet interdit) |

## Notions clés

| Notion | En bref |
|---|---|
| ACL standard | Filtre seulement sur l'adresse **source** ; à placer le plus près possible de la destination. |
| ACL étendue | Filtre sur la source, la destination, le protocole et le port ; à placer le plus près possible de la source. |
| Masque générique | Inverse du masque de sous-réseau : `0.0.0.255` correspond à un /24. |
| Refus implicite | Toute ACL se termine par un `deny any` invisible : ce qui n'est pas permis est bloqué. |
| `access-class` | Applique une ACL aux lignes VTY pour limiter qui peut se connecter en SSH. |

> [!NOTE]
> Les notes rédigées de ce cours sont **à compléter**. Les configurations réelles se trouvent dans les fichiers d'exercices ci-dessus.
