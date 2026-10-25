# Notes de cours — OSPF

**Routage dynamique à état de liens sur routeurs Cisco**

| Élément | Contenu |
|---|---|
| **Référent** | Le protocole de routage OSPF (Open Shortest Path First) sur Cisco IOS : voisinage, élection DR/BDR, zones et routeurs ABR. |
| **Émetteur** | Bariu Azeez |
| **Message** | Regrouper les notions et les configurations OSPF travaillées en classe, et indiquer l'exercice à consulter pour chacune. |
| **Récepteur** | M. Jérémy Massinon |
| **Canal** | Dépôt GitLab du cours (Collège de Rosemont), republié sur GitHub |
| **Code** | Français |
| **Référence** | [Cisco — IP Routing: OSPF Configuration Guide](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_ospf/configuration/xe-16/iro-xe-16-book/iro-cfg.html) |

---

## Documents du dossier

| Document | Contenu |
|---|---|
| [Exercice 2026-03-14](<Exercice-OSPF (2026-03-14).md>) | Configuration des commutateurs et routeurs, site par site |
| [Exercice 2026-03-20](<Exercice-OSPF (2026-03-20).md>) | Deuxième exercice OSPF |
| [Exercice 2026](<Exercice-OSPF(2026)>) | Configuration brute (fichier sans extension) |
| [Examen corrigé](EXAM-OSPF-corrigé.md) | Configuration corrigée de l'examen, équipement par équipement |

## Notions clés

| Notion | En bref |
|---|---|
| État de liens | Chaque routeur connaît la topologie complète de sa zone et calcule lui-même le plus court chemin (algorithme de Dijkstra). |
| Coût | Métrique OSPF, calculée à partir de la bande passante de l'interface. |
| DR / BDR | Sur un segment multi-accès (Ethernet), un routeur désigné et son remplaçant centralisent les échanges pour limiter le trafic. |
| Zones | La zone 0 (dorsale) relie toutes les autres ; un ABR est un routeur qui touche deux zones. |

> [!NOTE]
> Les notes rédigées de ce cours sont **à compléter**. Les configurations réelles se trouvent dans les fichiers d'exercices ci-dessus.
