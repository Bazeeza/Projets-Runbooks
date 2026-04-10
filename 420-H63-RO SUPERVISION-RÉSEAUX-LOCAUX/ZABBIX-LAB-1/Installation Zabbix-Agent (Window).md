## **Ajouter un hôte Windows** (agent installé)

0. Installé les package sur le site officiel Zibix agent windows installation (suivez les étapes qui suit apres l'installation)
1. **Configuration → Hosts → Create host**.
2. **Host name** : `WIN11-LAB` (doit correspondre au `Hostname=` de l’agent MSI).
3. **Groups** : ajoute `Windows servers` (ou crée un groupe).
4. **Interfaces** → **Add** → **Agent** :

   * **IP address** : IP du PC Windows
   * **Port** : `10050`
   * **Connect to** : IP (pas DNS si tu n’as pas de résolution)
5. **Templates** → **Select** → cherche et ajoute **`Windows by Zabbix agent`**.
6. **Encryption** (si non utilisée) : laisse **No encryption** (ou configure TLS si tu l’as fait côté agent).
7. **Add** pour créer l’hôte.
8. Va dans **Monitoring → Latest data**, filtre par `WIN11-LAB` et vérifie que les premiers items passent en **OK** (sinon attends 1–2 min).
9. Test rapide côté serveur (optionnel) :

   ```
   zabbix_get -s <IP_WINDOWS> -k agent.ping
   zabbix_get -s <IP_WINDOWS> -k system.hostname
   ```

   Tu dois recevoir `1` et le nom d’hôte.

---

