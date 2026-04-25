Tous les PCs du site A peuvent consulter les serveurs du site A en utilisant le nom de domaine.
Toutes les listes de contrôles d'accès doivent pouvoir comptabiliser toutes les communications.

Le VLAN 10 peut:
- Faire un PING et doit obtenir des réponses avec les PCs du VLAN 30.
- Consulter avec le serveur web-exam.com en utilisant le nom de domaine.


Le VLAN 20 peut:
- Communiquer uniquement avec les serveurs du site A.

Le VLAN 30 peut:
- Faire un PING et doit obtenir des réponses avec tous les appareils de réseaux du site A.
- Répondre à un PING du VLAN 10
- Consulter et télécharger/téléverser un fichier vers/depuis le serveur ftp-exam.com en utilisant le nom de domaine.

Le VLAN 40 peut:
- Ouvrir une session SSH sur tous les appareils de réseaux du site A


Vous devez configurer:
L'adressage IP public de R1 et R2.
La traduction d'adresses avec surcharge (PAT) sur R1 et R2.
La redirection de port sur R2 pour que les PCs du site A puissent consulter les seveurs du site B.
Les listes de contrôles d'accès.

 ## Corrigé complet TP3 — Objectif 70/70 (format Markdown)

> **Topologie (selon l’image)**

* **Site A**

  * VLAN 10 : 192.168.10.0/24 (PC VLAN10)
  * VLAN 20 : 192.168.20.0/24 (PC VLAN20)
  * VLAN 30 : 192.168.30.0/24 (PC VLAN30)
  * VLAN 40 : 192.168.40.0/24 (PC VLAN40)
  * VLAN 255 (serveurs site A) : 192.168.255.0/24

    * DNS : 192.168.255.10
    * WEB : 192.168.255.20
    * FTP : 192.168.255.30
  * Switch mgmt S1 : VLAN100 10.100.0.2/30 (GW 10.100.0.1)
  * Switch mgmt S2 : VLAN200 10.200.0.2/30 (GW 10.200.0.1)
* **Lien public**

  * R1 G0/0 : 209.10.10.1/30
  * R2 G0/0 : 209.10.10.2/30
* **Site B**

  * WEB : 172.16.255.10/24 (GW 172.16.255.1)
  * FTP : 172.16.255.20/24 (GW 172.16.255.1)

> **Objectifs**

* PAT sur R1 et R2
* Port-forwarding sur R2 pour accès site B depuis site A (WEB + FTP)
* ACL strictes par VLAN + **comptabilisation (log)**

---

## Configuration Switch S1 (site A — VLAN 10/20 + mgmt VLAN100)

```
ena
conf t
hostname S1
!
ip domain-name abdulm.local
username test privilege 15 secret test123
!
vlan 10
 name VLAN10
vlan 20
 name VLAN20
vlan 100
 name MGMT-S1
!
interface fa0/1
 description vers PC VLAN10
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast
 no shutdown
!
interface fa0/2
 description vers PC VLAN20
 switchport mode access
 switchport access vlan 20
 spanning-tree portfast
 no shutdown
!
interface gi0/1
 description trunk vers R1 (G0/1)
 switchport mode trunk
 switchport trunk allowed vlan 10,20,100
 no shutdown
!
interface vlan 100
 description Management S1
 ip address 10.100.0.2 255.255.255.252
 no shutdown
!
ip default-gateway 10.100.0.1
!
crypto key generate rsa modulus 1024
ip ssh version 2
line vty 0 15
 login local
 transport input ssh
end
wr
```

---

## Configuration Switch S2 (site A — VLAN 30/40/255 + mgmt VLAN200)

```
ena
conf t
hostname S2
!
ip domain-name abdulm.local
username test privilege 15 secret test123
!
vlan 30
 name VLAN30
vlan 40
 name VLAN40
vlan 255
 name SERVEURS-A
vlan 200
 name MGMT-S2
!
interface fa0/1
 description vers PC VLAN30
 switchport mode access
 switchport access vlan 30
 spanning-tree portfast
 no shutdown
!
interface fa0/2
 description vers PC VLAN40
 switchport mode access
 switchport access vlan 40
 spanning-tree portfast
 no shutdown
!
interface fa0/22
 description vers DNS site A (192.168.255.10)
 switchport mode access
 switchport access vlan 255
 spanning-tree portfast
 no shutdown
!
interface fa0/23
 description vers WEB site A (192.168.255.20)
 switchport mode access
 switchport access vlan 255
 spanning-tree portfast
 no shutdown
!
interface fa0/24
 description vers FTP site A (192.168.255.30)
 switchport mode access
 switchport access vlan 255
 spanning-tree portfast
 no shutdown
!
interface gi0/1
 description trunk vers R1 (G0/2)
 switchport mode trunk
 switchport trunk allowed vlan 30,40,200,255
 no shutdown
!
interface vlan 200
 description Management S2
 ip address 10.200.0.2 255.255.255.252
 no shutdown
!
ip default-gateway 10.200.0.1
!
crypto key generate rsa modulus 1024
ip ssh version 2
line vty 0 15
 login local
 transport input ssh
end
wr
```

---

## Configuration Switch S0 (site B — switch simple)

> (Ports à adapter selon ton câblage, l’idée est juste “access” partout)

```
ena
conf t
hostname S0
!
interface gi0/1
 description vers R2 (G0/1)
 switchport mode access
 no shutdown
!
interface fa0/1
 description vers serveur WEB site B
 switchport mode access
 no shutdown
!
interface fa0/2
 description vers serveur FTP site B
 switchport mode access
 no shutdown
end
wr
```

---

## Configuration Routeur R1 (site A — interVLAN + PAT + ACL + SSH)

```
ena
conf t
hostname R1
!
ip domain-name abdulm.local
username test privilege 15 secret test123
crypto key generate rsa modulus 1024
ip ssh version 2
!
interface g0/0
 description lien public vers R2
 ip address 209.10.10.1 255.255.255.252
 ip nat outside
 no shutdown
!
interface g0/1
 no shutdown
!
interface g0/1.10
 description Passerelle VLAN 10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0
 ip nat inside
 ip access-group VLAN10 in
 no shutdown
!
interface g0/1.20
 description Passerelle VLAN 20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
 ip nat inside
 ip access-group VLAN20 in
 no shutdown
!
interface g0/1.100
 description Management S1
 encapsulation dot1Q 100
 ip address 10.100.0.1 255.255.255.252
 ip nat inside
 no shutdown
!
interface g0/2
 no shutdown
!
interface g0/2.30
 description Passerelle VLAN 30
 encapsulation dot1Q 30
 ip address 192.168.30.1 255.255.255.0
 ip nat inside
 ip access-group VLAN30 in
 no shutdown
!
interface g0/2.40
 description Passerelle VLAN 40
 encapsulation dot1Q 40
 ip address 192.168.40.1 255.255.255.0
 ip nat inside
 ip access-group VLAN40 in
 no shutdown
!
interface g0/2.200
 description Management S2
 encapsulation dot1Q 200
 ip address 10.200.0.1 255.255.255.252
 ip nat inside
 no shutdown
!
interface g0/2.255
 description Serveurs site A
 encapsulation dot1Q 255
 ip address 192.168.255.1 255.255.255.0
 ip nat inside
 no shutdown
!
! Route vers site B via R2
ip route 172.16.0.0 255.255.0.0 209.10.10.2
!
! PAT Site A
access-list 1 permit 192.168.0.0 0.0.255.255
access-list 1 permit 10.0.0.0 0.255.255.255
ip nat inside source list 1 interface g0/0 overload
!
! =========================
! ACL VLAN10 (PING VLAN30 + DNS + HTTP web-exam.com)
! =========================
ip access-list extended VLAN10
 remark VLAN10 -> VLAN30 ping echo
 permit icmp 192.168.10.0 0.0.0.255 192.168.30.0 0.0.0.255 echo log
 remark VLAN30 -> VLAN10 ping reply
 permit icmp 192.168.30.0 0.0.0.255 192.168.10.0 0.0.0.255 echo-reply log
 remark VLAN10 -> DNS site A
 permit udp 192.168.10.0 0.0.0.255 host 192.168.255.10 eq domain log
 permit tcp 192.168.10.0 0.0.0.255 host 192.168.255.10 eq domain log
 remark VLAN10 -> WEB site B via IP publique R2 (web-exam.com)
 permit tcp 192.168.10.0 0.0.0.255 host 209.10.10.2 eq 80 log
 remark VLAN10 -> Serveurs site A
 permit ip 192.168.10.0 0.0.0.255 192.168.255.0 0.0.0.255 log
 remark Bloquer le reste
 deny ip 192.168.10.0 0.0.0.255 any log
!
! =========================
! ACL VLAN20 (uniquement serveurs site A + DNS)
! =========================
ip access-list extended VLAN20
 remark VLAN20 -> DNS site A
 permit udp 192.168.20.0 0.0.0.255 host 192.168.255.10 eq domain log
 permit tcp 192.168.20.0 0.0.0.255 host 192.168.255.10 eq domain log
 remark VLAN20 -> Serveurs site A seulement
 permit ip 192.168.20.0 0.0.0.255 192.168.255.0 0.0.0.255 log
 remark Bloquer le reste
 deny ip 192.168.20.0 0.0.0.255 any log
!
! =========================
! ACL VLAN30 (PING site A + répondre VLAN10 + FTP ftp-exam.com)
! =========================
ip access-list extended VLAN30
 remark VLAN30 <-> VLAN10 ping (echo)
 permit icmp 192.168.30.0 0.0.0.255 192.168.10.0 0.0.0.255 echo log
 remark VLAN10 -> VLAN30 ping reply
 permit icmp 192.168.10.0 0.0.0.255 192.168.30.0 0.0.0.255 echo-reply log
 remark VLAN30 -> ping reseaux site A (192.168.0.0/16)
 permit icmp 192.168.30.0 0.0.0.255 192.168.0.0 0.0.255.255 echo log
 remark VLAN30 -> ping reseaux site A (10.0.0.0/8) (mgmt switches)
 permit icmp 192.168.30.0 0.0.0.255 10.0.0.0 0.255.255.255 echo log
 remark Autoriser les echo-reply vers VLAN30
 permit icmp any 192.168.30.0 0.0.0.255 echo-reply log
 remark VLAN30 -> DNS site A (pour resoudre ftp-exam.com)
 permit udp 192.168.30.0 0.0.0.255 host 192.168.255.10 eq domain log
 permit tcp 192.168.30.0 0.0.0.255 host 192.168.255.10 eq domain log
 remark VLAN30 -> FTP site B via IP publique R2
 permit tcp 192.168.30.0 0.0.0.255 host 209.10.10.2 eq 21 log
 permit tcp 192.168.30.0 0.0.0.255 host 209.10.10.2 eq 20 log
 remark VLAN30 -> Serveurs site A (optionnel mais propre)
 permit ip 192.168.30.0 0.0.0.255 192.168.255.0 0.0.0.255 log
 remark Bloquer le reste
 deny ip 192.168.30.0 0.0.0.255 any log
!
! =========================
! ACL VLAN40 (SSH seulement vers reseaux site A + DNS optionnel)
! =========================
ip access-list extended VLAN40
 remark VLAN40 -> SSH vers reseaux site A (192.168.0.0/16)
 permit tcp 192.168.40.0 0.0.0.255 192.168.0.0 0.0.255.255 eq 22 log
 remark VLAN40 -> SSH vers reseaux site A (10.0.0.0/8) mgmt
 permit tcp 192.168.40.0 0.0.0.255 10.0.0.0 0.255.255.255 eq 22 log
 remark VLAN40 -> DNS site A (si on utilise des noms)
 permit udp 192.168.40.0 0.0.0.255 host 192.168.255.10 eq domain log
 permit tcp 192.168.40.0 0.0.0.255 host 192.168.255.10 eq domain log
 remark Bloquer le reste
 deny ip 192.168.40.0 0.0.0.255 any log
!
line vty 0 15
 login local
 transport input ssh
end
wr
```

---

## Configuration Routeur R2 (site B — PAT + Port Forwarding complet)

```
ena
conf t
hostname R2
!
interface g0/0
 description lien public vers R1
 ip address 209.10.10.2 255.255.255.252
 ip nat outside
 no shutdown
!
interface g0/1
 description LAN serveurs site B
 ip address 172.16.255.1 255.255.255.0
 ip nat inside
 no shutdown
!
! PAT site B
access-list 1 permit 172.16.0.0 0.0.255.255
ip nat inside source list 1 interface g0/0 overload
!
! Port forwarding (WEB + FTP control + FTP data)
ip nat inside source static tcp 172.16.255.10 80 209.10.10.2 80
ip nat inside source static tcp 172.16.255.20 21 209.10.10.2 21
ip nat inside source static tcp 172.16.255.20 20 209.10.10.2 20
end
wr
```

---

## Configuration des PCs (site A)

> À faire dans **Desktop > IP Configuration**

* PC VLAN10 :

  * IP : 192.168.10.10 /24
  * GW : 192.168.10.1
  * DNS : 192.168.255.10
* PC VLAN20 :

  * IP : 192.168.20.10 /24
  * GW : 192.168.20.1
  * DNS : 192.168.255.10
* PC VLAN30 :

  * IP : 192.168.30.10 /24
  * GW : 192.168.30.1
  * DNS : 192.168.255.10
* PC VLAN40 :

  * IP : 192.168.40.10 /24
  * GW : 192.168.40.1
  * DNS : 192.168.255.10

---

## Configuration des serveurs site A (VLAN255)

* DNS : 192.168.255.10 /24 — GW 192.168.255.1
* WEB : 192.168.255.20 /24 — GW 192.168.255.1
* FTP : 192.168.255.30 /24 — GW 192.168.255.1

---

## Configuration DNS (sur le serveur DNS site A — 192.168.255.10)

Dans **Services > DNS** (ON), ajouter :

* `web-exam.com`  → **209.10.10.2**
* `ftp-exam.com`  → **209.10.10.2**
* (optionnel) `web-h66.com` → 192.168.255.20
* (optionnel) `ftp-h66.com` → 192.168.255.30

---

## Tests à faire (validation 70/70)

1. Depuis PC VLAN10 :

   * `ping 192.168.30.10` ✅
   * navigateur : `http://web-exam.com` ✅
2. Depuis PC VLAN20 :

   * accès serveurs site A uniquement (ex : ping/HTTP vers 192.168.255.20) ✅
   * pas d’accès vers site B ✅
3. Depuis PC VLAN30 :

   * ping R1/S1/S2/serveurs site A ✅
   * `ftp ftp-exam.com` (upload/download) ✅
4. Depuis PC VLAN40 :

   * `ssh -l test 192.168.10.1` / `ssh -l test 10.100.0.2` / etc ✅
5. Sur R1 :

   * `show access-lists` → tu dois voir des logs défiler et/ou des hits ✅
