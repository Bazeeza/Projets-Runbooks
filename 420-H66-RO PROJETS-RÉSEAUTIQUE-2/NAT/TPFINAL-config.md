## Ordre de configuration OSPF (important !)

```
1. Rt-Frontiere-A  → DR (priority 255), a la route par défaut
2. RT-1            → BDR (priority 200), ABR Area 0 + Area 1
3. RT-2            → DROTHER (priority 0 Zone-0), ABR Area 0 + Area 1
4. RT-3            → Interne Area 1
5. RT-4            → Interne Area 1
6. Switches        → Après tous les routeurs
```
---

## Types de câbles

| Connexion | Câble |
|-----------|-------|
| Routeur ↔ Routeur | Auto (ou Cross-Over) |
| Routeur ↔ Switch | Auto (ou Straight-Through) |
---

## NAT/PAT — Pourquoi C'EST nécessaire ?

Zone verte et zone marron utilisent **le même subnet 172.16.100.0/24**. Sans NAT sur Rt-Entreprise-B, les paquets de retour vont vers la zone marron au lieu de la zone verte. 
Le NAT/PAT traduit le trafic zone verte vers 203.0.113.65 (IP WAN).

---

## ROUTEURS

### Rt-Frontiere-A — Configurer EN PREMIER

```
ena
conf t
hostname Rt-Frontiere-A
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
login local
transport input ssh
exit
!
! ===== INTERFACES EN PREMIER =====
!
interface gig0/0
 description vers COM-0 Zone-0
 ip address 10.255.255.252 255.255.255.248
 ip ospf priority 255
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface gig0/1
 description vers Rt-Entreprise-B WAN
 ip address 203.0.113.66 255.255.255.252
 no shut
!
! ===== OSPF APRES LES INTERFACES =====
!
router ospf 1
 router-id 5.5.5.5
! (default-information originate est accepté sans always sur le routeur)
 default-information originate
 passive-interface default
 no passive-interface gig0/0
 !
 area 0 authentication message-digest
 !
 network 10.255.255.248 0.0.0.7 area 0
!
! ===== ROUTE PAR DEFAUT =====
!
ip route 0.0.0.0 0.0.0.0 203.0.113.65
!
end
wr
```

---

### RT-1 — Configurer EN DEUXIEME (BDR + ABR)

```
ena
conf t
hostname RT-1
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
login local
transport input ssh
exit
!
! ===== INTERFACES EN PREMIER =====
!
interface gig2/0
 description vers COM-0 Zone-0
 ip address 10.255.255.249 255.255.255.248
 ip ospf priority 200
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface gig1/0
 description vers RT-3
 bandwidth 1000000
 ip address 10.255.254.1 255.255.255.252
 ip ospf priority 200
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface gig0/0
 description vers RT-2
 bandwidth 1000000
 ip address 10.255.254.5 255.255.255.252
 ip ospf priority 200
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface eth3/0
 description vers RT-4
 bandwidth 10000
 ip address 10.255.254.9 255.255.255.252
 ip ospf priority 200
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
! ===== OSPF APRES LES INTERFACES =====
!
router ospf 1
 router-id 1.1.1.1
 passive-interface default
 no passive-interface gig2/0
 no passive-interface gig0/0
 no passive-interface gig1/0
 no passive-interface eth3/0
 !
 area 0 authentication message-digest
 area 1 authentication message-digest
 !
 area 1 range 192.168.0.0 255.255.0.0
 !
 network 10.255.255.248 0.0.0.7 area 0
 network 10.255.254.0 0.0.0.3 area 1
 network 10.255.254.4 0.0.0.3 area 1
 network 10.255.254.8 0.0.0.3 area 1
!
end
wr
```

---

### RT-2 — Configurer EN TROISIEME (DROTHER + ABR)

```
ena
conf t
hostname RT-2
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
 login local
 transport input ssh
 exit
!
! ===== INTERFACES EN PREMIER =====
!
interface fa2/0
 description vers COM-0 Zone-0
 ip address 10.255.255.251 255.255.255.248
 ip ospf priority 0
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface gig0/0
 description vers RT-1
 bandwidth 1000000
 ip address 10.255.254.6 255.255.255.252
 ip ospf priority 1
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface gig1/0
 description vers RT-3
 bandwidth 1000000
 ip address 10.255.254.21 255.255.255.252
 ip ospf priority 1
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface eth3/0
 description vers RT-4
 bandwidth 10000
 ip address 10.255.254.17 255.255.255.252
 ip ospf priority 1
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface gig4/0
 description vers COM-3 zone-marron
 ip address 172.16.100.254 255.255.255.0
 no shut
!
! ===== OSPF APRES LES INTERFACES =====
!
router ospf 1
 router-id 2.2.2.2
 passive-interface default
 no passive-interface fa2/0
 no passive-interface gig0/0
 no passive-interface gig1/0
 no passive-interface eth3/0
 !
 area 0 authentication message-digest
 area 1 authentication message-digest
 !
 area 1 range 192.168.0.0 255.255.0.0
 !
 network 10.255.255.248 0.0.0.7 area 0
 network 10.255.254.4 0.0.0.3 area 1
 network 10.255.254.16 0.0.0.3 area 1
 network 10.255.254.20 0.0.0.3 area 1
 network 172.16.100.0 0.0.0.255 area 1
!
end
wr
```

---

### RT-3 — Configurer EN QUATRIEME

```
ena
conf t
hostname RT-3
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
 login local
 transport input ssh
 exit
!
! ===== INTERFACES EN PREMIER =====
!
interface gig0/0
 description vers RT-1
 bandwidth 1000000
 ip address 10.255.254.2 255.255.255.252
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface gig1/0
 description vers RT-2
 bandwidth 1000000
 ip address 10.255.254.22 255.255.255.252
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface fa2/0
 description vers RT-4
 bandwidth 100000
 ip address 10.255.254.13 255.255.255.252
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 shutdown
 no shutdown
!
interface gig3/0
 description vers COM-2 trunk
 no ip address
 no shut
!
interface gig3/0.1
 description Management-COM-2
 encapsulation dot1Q 1 native
 ip address 172.29.255.2 255.255.255.252
 no shut
!
interface gig3/0.110
 description VLAN-110
 encapsulation dot1Q 110
 ip address 192.168.110.254 255.255.255.0
 no shut
!
interface gig3/0.220
 description VLAN-220
 encapsulation dot1Q 220
 ip address 192.168.220.254 255.255.255.0
 no shut
!
! ===== OSPF APRES LES INTERFACES =====
!
router ospf 1
 router-id 3.3.3.3
 passive-interface default
 no passive-interface gig0/0
 no passive-interface gig1/0
 no passive-interface fa2/0
 !
 area 1 authentication message-digest
 !
 network 10.255.254.0 0.0.0.3 area 1
 network 10.255.254.12 0.0.0.3 area 1
 network 10.255.254.20 0.0.0.3 area 1
 network 192.168.110.0 0.0.0.255 area 1
 network 192.168.220.0 0.0.0.255 area 1
 network 172.29.255.0 0.0.0.3 area 1
!
end
wr
```

---

### RT-4 — Configurer EN CINQUIEME

```
ena
conf t
hostname RT-4
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
 login local
 transport input ssh
 exit
!
! ===== INTERFACES EN PREMIER =====
!
interface eth4/0
 description vers RT-1
 bandwidth 10000
 ip address 10.255.254.10 255.255.255.252
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface eth5/0
 description vers RT-2
 bandwidth 10000
 ip address 10.255.254.18 255.255.255.252
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 no shut
!
interface fa3/0
 description vers RT-3
 bandwidth 100000
 ip address 10.255.254.14 255.255.255.252
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CISCO
 ip ospf hello-interval 5
 ip ospf dead-interval 20
 shutdown
 no shutdown
!
interface gig0/0
 description vers COM-1 trunk
 no ip address
 no shut
!
interface gig0/0.1
 description Management-COM-1
 encapsulation dot1Q 1 native
 ip address 172.29.255.6 255.255.255.252
 no shut
!
interface gig0/0.330
 description VLAN-330
 encapsulation dot1Q 330
 ip address 192.168.130.254 255.255.255.0
 no shut
!
interface gig0/0.440
 description VLAN-440
 encapsulation dot1Q 440
 ip address 192.168.140.254 255.255.255.0
 no shut
!
! ===== OSPF APRES LES INTERFACES =====
! NOTE: RT-4 n'est PAS un ABR - pas de area range ici
!
router ospf 1
 router-id 4.4.4.4
 passive-interface default
 no passive-interface eth4/0
 no passive-interface eth5/0
 no passive-interface fa3/0
 !
 area 1 authentication message-digest
 !
 network 10.255.254.8 0.0.0.3 area 1
 network 10.255.254.12 0.0.0.3 area 1
 network 10.255.254.16 0.0.0.3 area 1
 network 192.168.130.0 0.0.0.255 area 1
 network 192.168.140.0 0.0.0.255 area 1
 network 172.29.255.4 0.0.0.3 area 1
!
end
wr
```
---

### Rt-Entreprise-B — Avec NAT/PAT

```
ena
conf t
hostname Rt-Entreprise-B
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
 login local
 transport input ssh
 exit
!
! ===== INTERFACES =====
!
interface gig0/1
 description vers Rt-Frontiere-A WAN
 ip address 203.0.113.65 255.255.255.252
 ip nat outside
 no shut
!
interface gig0/0
 description vers SW-1 zone-verte
 ip address 172.16.100.1 255.255.255.0
 ip nat inside
 no shut
!
! ===== NAT PAT - Zone verte vers WAN =====
!
access-list 10 permit 172.16.100.0 0.0.0.255
ip nat inside source list 10 interface gig0/1 overload
!
! ===== ROUTES STATIQUES =====
!
ip route 192.168.0.0 255.255.0.0 203.0.113.66
ip route 10.255.255.248 0.0.0.7 203.0.113.66
ip route 172.29.255.0 255.255.255.248 203.0.113.66
!
end
wr
```

---

## SWITCHES

### Com-0 — Zone 0

```
ena
conf t
hostname Com-0
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
 login local
 transport input ssh
 exit
!
interface fa0/1
 description vers RT-2
 switchport mode access
 no shut
!
interface gig0/1
 description vers RT-1
 switchport mode access
 no shut
!
interface gig0/2
 description vers Rt-Frontiere-A
 switchport mode access
 no shut
!
interface vlan 1
 ip address 10.255.255.250 255.255.255.248
 no shut
!
ip default-gateway 10.255.255.249
!
end
wr
```

---

### Com-1 — VLAN 330 et 440

```
ena
conf t
hostname Com-1
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
 login local
 transport input ssh
 exit
!
vlan 330
 name VLAN-330
!
vlan 440
 name VLAN-440
!
interface fa0/13
 description vers PC-VLAN-330
 switchport mode access
 switchport access vlan 330
 spanning-tree portfast
 no shut
!
interface fa0/1
 description vers PC-VLAN-440
 switchport mode access
 switchport access vlan 440
 spanning-tree portfast
 no shut
!
interface gig0/1
 description vers RT-4 trunk
 switchport mode trunk
 switchport trunk allowed vlan 1,330,440
 no shut
!
interface vlan 1
 ip address 172.29.255.5 255.255.255.252
 no shut
!
ip default-gateway 172.29.255.6
!
end
wr
```

---

### Com-2 — VLAN 110 et 220

```
ena
conf t
hostname Com-2
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
 login local
 transport input ssh
 exit
!
vlan 110
 name VLAN-110
!
vlan 220
 name VLAN-220
!
interface fa0/13
 description vers PC-VLAN-110
 switchport mode access
 switchport access vlan 110
 spanning-tree portfast
 no shut
!
interface fa0/1
 description vers PC-VLAN-220
 switchport mode access
 switchport access vlan 220
 spanning-tree portfast
 no shut
!
interface gig0/1
 description vers RT-3 trunk
 switchport mode trunk
 switchport trunk allowed vlan 1,110,220
 no shut
!
interface vlan 1
 ip address 172.29.255.1 255.255.255.252
 no shut
!
ip default-gateway 172.29.255.2
!
end
wr
```

---

### Com-3 — Zone marron

```
ena
conf t
hostname Com-3
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
 login local
 transport input ssh
 exit
!
interface fa0/1
 description vers Web-H666
 switchport mode access
 spanning-tree portfast
 no shut
!
interface fa0/2
 description vers FTP-H666
 switchport mode access
 spanning-tree portfast
 no shut
!
interface fa0/3
 description vers DHCP-H666
 switchport mode access
 spanning-tree portfast
 no shut
!
interface fa0/4
 description vers DNS-H666
 switchport mode access
 spanning-tree portfast
 no shut
!
interface fa0/5
 description vers TFTP-H666
 switchport mode access
 spanning-tree portfast
 no shut
!
interface gig0/1
 description vers RT-2
 switchport mode access
 no shut
!
interface vlan 1
 ip address 172.16.100.2 255.255.255.0
 no shut
!
ip default-gateway 172.16.100.254
!
end
wr
```

---

### SW-1 — Zone verte

```
ena
conf t
hostname SW-1
!
no ip domain-lookup
ip domain-name entreprise.local
!
username admin privilege 15 secret cisco123
!
crypto key generate rsa
1024
!
ip ssh version 2
!
line vty 0 15
 login local
 transport input ssh
 exit
!
interface fa0/1
 description vers FTP-Lucifer
 switchport mode access
 spanning-tree portfast
 no shut
!
interface fa0/2
 description vers Web-Lucifer
 switchport mode access
 spanning-tree portfast
 no shut
!
interface gig0/1
 description vers Rt-Entreprise-B
 switchport mode access
 no shut
!
interface vlan 1
 ip address 172.16.100.3 255.255.255.0
 no shut
!
ip default-gateway 172.16.100.1
!
end
wr
```

---

## Tableau d'interconnexion des IPs

| Équipement | Interface | IP | Réseau |
|-----------|-----------|-----|--------|
| Rt-Frontiere-A | gig0/0 | 10.255.255.252/29 | Zone-0 |
| Rt-Frontiere-A | gig0/1 | 203.0.113.66/30 | WAN |
| RT-1 | gig2/0 | 10.255.255.249/29 | Zone-0 |
| RT-2 | fa2/0 | 10.255.255.251/29 | Zone-0 |
| Com-0 | VLAN1 | 10.255.255.250/29 | Zone-0 |
| RT-1 | gig1/0 | 10.255.254.1/30 | ↔RT-3 |
| RT-3 | gig0/0 | 10.255.254.2/30 | ↔RT-1 |
| RT-1 | gig0/0 | 10.255.254.5/30 | ↔RT-2 |
| RT-2 | gig0/0 | 10.255.254.6/30 | ↔RT-1 |
| RT-1 | eth3/0 | 10.255.254.9/30 | ↔RT-4 |
| RT-4 | eth4/0 | 10.255.254.10/30 | ↔RT-1 |
| RT-3 | fa2/0 | 10.255.254.13/30 | ↔RT-4 |
| RT-4 | fa3/0 | 10.255.254.14/30 | ↔RT-3 |
| RT-2 | eth3/0 | 10.255.254.17/30 | ↔RT-4 |
| RT-4 | eth5/0 | 10.255.254.18/30 | ↔RT-2 |
| RT-2 | gig1/0 | 10.255.254.21/30 | ↔RT-3 |
| RT-3 | gig1/0 | 10.255.254.22/30 | ↔RT-2 |
| RT-3 | gig3/0.1 | 172.29.255.2/30 | Mgmt-Com2 |
| RT-3 | gig3/0.110 | 192.168.110.254/24 | VLAN-110 |
| RT-3 | gig3/0.220 | 192.168.220.254/24 | VLAN-220 |
| RT-4 | gig0/0.1 | 172.29.255.6/30 | Mgmt-Com1 |
| RT-4 | gig0/0.330 | 192.168.130.254/24 | VLAN-330 |
| RT-4 | gig0/0.440 | 192.168.140.254/24 | VLAN-440 |
| RT-2 | gig4/0 | 172.16.100.254/24 | Zone-marron |
| Rt-Entreprise-B | gig0/1 | 203.0.113.65/30 | WAN |
| Rt-Entreprise-B | gig0/0 | 172.16.100.1/24 | Zone-verte |
| Com-0 | VLAN1 | 10.255.255.250/29 | Zone-0 |
| Com-1 | VLAN1 | 172.29.255.5/30 | Mgmt |
| Com-2 | VLAN1 | 172.29.255.1/30 | Mgmt |
| Com-3 | VLAN1 | 172.16.100.2/24 | Zone-marron |
| SW-1 | VLAN1 | 172.16.100.3/24 | Zone-verte |

---

## Adresses PCs

| PC | VLAN | IP | Masque | Gateway | DNS |
|----|------|----|--------|---------|-----|
| PC VLAN-110 | 110 | 192.168.110.55 | /24 | 192.168.110.254 | 172.16.100.40 |
| PC VLAN-220 | 220 | 192.168.220.55 | /24 | 192.168.220.254 | 172.16.100.40 |
| PC VLAN-330 | 330 | 192.168.130.55 | /24 | 192.168.130.254 | 172.16.100.40 |
| PC VLAN-440 | 440 | 192.168.140.55 | /24 | 192.168.140.254 | 172.16.100.40 |

---

## Après configuration — Vérification obligatoires

```
! 1. Sur RT-2 — Forcer priorité 0 et re-élection si nécessaire :
ena
conf t
interface fa2/0
 ip ospf priority 0
end
clear ip ospf process
! Répondre : yes

! 2. Vérifier DR/BDR sur Rt-Frontiere-A :
show ip ospf neighbor
! Attendu : RT-1 = BDR, RT-2 = DROTHER

! 3. Vérifier route par défaut sur RT-3 et RT-4 :
show ip route | include 0.0.0.0
! Attendu : O*E2 0.0.0.0/0

! 4. Vérifier NAT sur Rt-Entreprise-B :
show ip nat translations
```



# Configuration ACL



