# NAT et PAT  .....
**Auteur But et Schéma planification**

| Élément        | Contenu         |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Référent**   | Notes de Cours x |
| **Émetteur**   | **Abdul-Bariu**    |
| **Message**    | Présenter/documenter .       |
| **Récepteur**  | M. Jérémy Massinon           |
| **Canal**      | GitLab                                |
| **Code**       | Français                                                                                                        |
| **Références** | [Vaultwarden](https://github.com/dani-garcia/vaultwarden) · [Terraform](https://developer.hashicorp.com/terraform/docs) · [AWS EC2 Docs](https://docs.aws.amazon.com/fr_fr/ec2/) · [AWS VPC Docs](https://docs.aws.amazon.com/vpc/) · |

Le deuxième article de la série discute des termes NAT vs PAT, et Statique vs Dynamique. Le truc, c'est :

```
- Network Address Translation, ou NAT, implique une traduction d'une adresse IP vers une autre adresse IP.
- Port Address Translation, ou PAT, implique une traduction d'une adresse IP et d'un port vers une autre adresse IP et un autre port.
```
Statique -- les attributs post-traduction sont explicitement définis par l'administrateur (adresse IP pour un NAT, ou IP:Port pour un PAT)
Dynamique -- les attributs post-traduction sont sélectionnés par le routeur au moment où le paquet est reçu
Entre ces quatre termes, tu peux obtenir quatre combinaisons possibles de traduction d'adresse :
```
NAT statique
PAT statique
PAT dynamique
NAT dynamique
```
