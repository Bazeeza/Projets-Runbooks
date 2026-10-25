# Ajout d'un hôte Windows à Zabbix

**Enregistrer un poste Windows 11 équipé de l'agent Zabbix dans l'interface du serveur**

| Élément | Contenu |
|---|---|
| **Référent** | L'ajout d'un poste Windows 11 (agent Zabbix installé par MSI) comme hôte supervisé dans Zabbix 7.0 LTS. |
| **Émetteur** | Bariu Azeez |
| **Message** | Créer l'hôte, lui associer le modèle Windows et vérifier que les premières données remontent. |
| **Récepteur** | Étudiants et techniciens du laboratoire de supervision |
| **Canal** | Dépôt GitLab du cours (Collège de Rosemont), republié sur GitHub |
| **Code** | Français |
| **Référence** | [Zabbix — Agent Windows (installation MSI)](https://www.zabbix.com/documentation/7.0/en/manual/installation/install_from_packages/win_msi) · [Zabbix — Configuration d'un hôte](https://www.zabbix.com/documentation/7.0/en/manual/config/hosts/host) |

---

## Prérequis

Installer l'agent Zabbix pour Windows à partir du paquet MSI officiel (voir la référence ci-dessus), puis suivre les étapes ci-dessous dans l'interface web du serveur.

## Procédure

1. **Configuration → Hosts → Create host**.
2. **Host name** : `WIN11-LAB` (doit correspondre au paramètre `Hostname=` de l'agent MSI).
3. **Groups** : ajouter `Windows servers` (ou créer un groupe).
4. **Interfaces** → **Add** → **Agent** :
   * **IP address** : adresse IP du PC Windows
   * **Port** : `10050`
   * **Connect to** : IP (pas DNS s'il n'y a pas de résolution de noms)
5. **Templates** → **Select** → chercher et ajouter **`Windows by Zabbix agent`**.
6. **Encryption** : laisser **No encryption**, sauf si TLS a été configuré côté agent.
7. **Add** pour créer l'hôte.
8. Ouvrir **Monitoring → Latest data**, filtrer sur `WIN11-LAB` et vérifier que les premiers éléments passent à **OK** (sinon, attendre 1 à 2 minutes).
9. Test rapide côté serveur (facultatif) :

   ```
   zabbix_get -s <IP_WINDOWS> -k agent.ping
   zabbix_get -s <IP_WINDOWS> -k system.hostname
   ```

   Le serveur doit recevoir `1`, puis le nom d'hôte.

> [!NOTE]
> Le port `10050/TCP` doit être ouvert dans le pare-feu Windows pour que le serveur puisse interroger l'agent (vérifications passives).
