```
DEMANDES ACL CONF
Le VLAN 10 ne peut pas consulter les serveurs.
Le VLAN 10 peut envoyer des requêtes PING à tous les autres VLAN de PCs. (Tous les VLANs doivent répondre)
Le VLAN 20 peut seulement envoyer des requêtes PING au VLAN 30 et VLAN 60 (Les VLANs 30 et 60 doivent répondre)
Le VLAN 30 ne peut pas communiquer avec le VLAN 40
Le VLAN 30 peut envoyer des requêtes PING à tous les autres VLAN de PCs. (Tous les VLANs doivent répondre)
Le VLAN 40 est le seul à pouvoir se connecter à distance sur les équipements réseaux en SSH (pas de TELNET)
Le VLAN 50 peut uniquement communiquer avec les serveurs.
Le VLAN 60 peut tout faire, sauf se connecter aux appareils réseaux
===========================================================================
========Switch-1-Configuration ============================================
===========================================================================
ena
conf t
hostname SW-1
!
vlan 0
name vlan10
vlan 20
name vlan20
vlan 666
name vlanGestion
!
interface fa0/1
description vers vlan10
switchport mode access
switchport access vlan 10
spanning-tree portfast
no shut
!
interface fa0/13
description vers vlan20
switchport mode access
switchport access vlan 20
spanning-tree portfast
no shut
!
interface gi0/1
description vers R0
switchport mode trunk
switchport trunk allowed vlan 10,20,666
no shut
!
interface vlan 666
description vlanGestion
ip address 192.168.0.2 255.255.255.252
no shut
!
ip default-gateway 192.168.0.1 255.255.255.252
!
ip domain-name azeez.local
username admin privilage 15 secret crosemont
crypto key generate rsa modulus 1024
ip ssh version 2
line vty 0 15
login local
transport input ssh
!
end
!
wr
===========================================================================
========Switch-2-Configuration ============================================
===========================================================================

ena
conf t
hostname SW-2
!
vlan 30
name vlan10
vlan 40
name vlan20
vlan 666
name vlanGestion
!
interface fa0/1
description vers vlan30
switchport mode access
switchport access vlan 30
spanning-tree portfast
no shut
!
interface fa0/13
description vers vlan40
switchport mode access
switchport access vlan 40
spanning-tree portfast
no shut
!
interface gi0/1
description vers R1
switchport mode trunk
switchport trunk allowed vlan 30,40,666
no shut
!
interface vlan 666
description vlanGestion
ip address 192.168.0.6 255.255.255.252
no shut
!
ip default-gateway 192.168.0.5 255.255.255.252
!
ip domain-name azeez.local
username admin privilage 15 secret crosemont
crypto key generate rsa modulus 1024
ip ssh version 2
line vty 0 15
login local
transport input ssh
!
end
!
wr
===========================================================================
========Switch-3-Configuration ============================================
===========================================================================

ena
conf t
hostname SW-3
!
vlan 50
name vlan10
vlan 60
name vlan20
vlan 666
name vlanGestion
!
interface fa0/1
description vers vlan50
switchport mode access
switchport access vlan 50
spanning-tree portfast
no shut
!
interface fa0/13
description vers vlan60
switchport mode access
switchport access vlan 60
spanning-tree portfast
no shut
!
interface gi0/1
description vers R2
switchport mode trunk
switchport trunk allowed vlan 50,60,666
no shut
!
interface vlan 666
description vlanGestion
ip address 192.168.0.10 255.255.255.252
no shut
!
ip default-gateway 192.168.0.9 255.255.255.252
!
ip domain-name azeez.local
username admin privilage 15 secret crosemont
crypto key generate rsa modulus 1024
ip ssh version 2
line vty 0 15
login local
transport input ssh
!
end
!
wr
===========================================================================
========Switch-4-Configuration ============================================
===========================================================================

ena
conf t
hostname SW-4
!
vlan 255
name vlan255
vlan 666
name vlanGestion
!
interface fa0/1
description vers vlan 255
switchport mode access
switchport access vlan 255
spanning-tree portfast
no shut
!
interface fa0/2
description vers vlan255
switchport mode access
switchport access vlan 255
spanning-tree portfast
no shut
!
interface gi0/1
description vers R2
switchport mode trunk
switchport trunk allowed vlan 255,666
no shut
!
interface vlan 666
description vlanGestion
ip address 192.168.0.14 255.255.255.252
no shut
!
ip default-gateway 192.168.0.13 255.255.255.252
!
ip domain-name azeez.local
username admin privilage 15 secret crosemont
crypto key generate rsa modulus 1024
ip ssh version 2
line vty 0 15
login local
transport input ssh
!
end
!
wr

==========================================================================================================================================================================================================================================================================================================================
Le VLAN 10 ne peut pas consulter les serveurs.
Le VLAN 10 peut envoyer des requêtes PING à tous les autres VLAN de PCs. (Tous les VLANs doivent répondre)
Le VLAN 20 peut seulement envoyer des requêtes PING au VLAN 30 et VLAN 60 (Les VLANs 30 et 60 doivent répondre)
Le VLAN 30 ne peut pas communiquer avec le VLAN 40
Le VLAN 30 peut envoyer des requêtes PING à tous les autres VLAN de PCs. (Tous les VLANs doivent répondre)
Le VLAN 40 est le seul à pouvoir se connecter à distance sur les équipements réseaux en SSH (pas de TELNET)
Le VLAN 50 peut uniquement communiquer avec les serveurs.
Le VLAN 60 peut tout faire, sauf se connecter aux appareils réseaux
=======================================================
=======================================================
=======================================================
ena
conf t
hostname R0
!
interface gi0/0
description Trunk-vers-Sw3
no ip address
no shut
!
interface gi0/0.10
encapsulation dot1q 10
ip address 10.1.10.254 255.255.255.0
ip access-group ACL_VLAN10_IN in
ip access-group ACL_VLAN10_OUT out
no shut
!
interface gi0/0.20
encapsulation dot1q 20
ip address 10.1.20.254 255.255.255.0
ip access-group ACL_VLAN20_IN in
ip access-group ACL_VLAN20_OUT out
no shut
!
interface gi0/0.666
encapsulation dot1q 666
ip address 192.168.0.1 255.255.255.252
ip access-group ACL_666_IN in
ip access-group out ACL_666_OUT out
no shut
!
interface gi0/1
description vers R1
ip address 172.16.0.1 255.255.255.252
no shut
!
!IP ROUTES
ip route 10.1.30.0 255.255.255.0 172.16.0.2
ip route 10.1.40.0 255.255.255.0 172.16.0.2
ip route 10.1.50.0 255.255.255.0 172.16.0.2
ip route 10.1.60.0 255.255.255.0 172.16.0.2
ip route 10.0.255.0 255.255.255.0 172.16.0.2
!
ip route 192.168.0.4 255.255.255.252 172.16.0.2
ip route 192.168.0.8 255.255.255.252 172.16.0.2
ip route 192.168.0.12 255.255.255.252 172.16.0.2
!
!REGLES ACLs
!
ip access-list extended ACL_VLAN10_IN
remark autorise dhcp client server
permit udp any eq 68 any eq 67
permit udp any eq 67 any eq 68
!
remark autorise ping vers vlan10_20_30_40_50_60
permit icmp 10.1.10.0 0.0.0.255 10.1.10.0 0 0.0.0.255 echo
permit icmp 10.1.10.0 0.0.0.255 10.1.20.0 0 0.0.0.255 echo
permit icmp 10.1.10.0 0.0.0.255 10.1.30.0 0 0.0.0.255 echo
permit icmp 10.1.10.0 0.0.0.255 10.1.40.0 0 0.0.0.255 echo
permit icmp 10.1.10.0 0.0.0.255 10.1.50.0 0 0.0.0.255 echo
permit icmp 10.1.10.0 0.0.0.255 10.1.60.0 0 0.0.0.255 echo
!
remark refuse connection vers les serveurs
deny ip 10.1.10.0 0.0.0.255 host 10.0.255.10
deny ip 10.1.10.0 0.0.0.255 host 10.0.255.20
!
ip access-list extended ACL_VLAN20_IN
!
remark autorise dhcp
permit udp any eq 68 any eq 67
permit udp any eq 67 any eq 68
!
remark autorise reponse vers vlan10
!
permit icmp 10.1.20.0 0.0.0.255 10.1.10.0 255.255.255.0 echo-reply
!
remark ping vers vlan30 et vlan60 + refuse tout reste
permit icmp 10.1.20.0 0.0.0.255 10.1.30.0 255.255.255.0 echo
permit icmp 10.1.20.0 0.0.0.255 10.1.60.0 255.255.255.0 echo
deny ip 10.1.20.0 0.0.0.255 any
!
ip access-list standard SSH_VLAN40
permit 10.1.40.0 0.0.0.255
deny any any
!
ip domain-name azeez.local
username admin privilege 15 secret cr
crypto key generate rsa modulus 1024
ip ssh version 2
line vty 0 15
login local
transport input ssh
access-class SSH_VLAN40 in
!
end
!
wr

=======================================================
=======================================================
=======================================================



ena
conf t
hostname R1
!
interface gi0/0
description vers trunk switch-2
no ip address
no shut
!
interface gi0/0.30
encapsulation dot1q 30
ip address 10.1.30.254 255.255.255.0
ip access-group ACL_VLAN30_IN in
ip access-group ACL_VLAN30_OUT out
no shut
!
interface gi0/0.40
encapsulation dot1q 40
ip address 10.1.40.254 255.255.255.0
ip access-group in ACL-VLAN40-IN
no shut
!
interface gi0/0.666
encapsulation dot1q 666
ip address 192.168.0.5 255.255.255.252
no shut
!
interface gi0/1
description vers R0
ip address 172.16.0.2 255.255.255.252
no shut
!
interface gi0/2
description vers R2
ip address 172.16.0.5 255.255.255.252
no shut
!
!IP ROUTES
!
ip route 10.1.10.0 255.255.255.0 172.16.0.1
ip route 10.1.20.0 255.255.255.0 172.16.0.1
ip route 10.1.50.0 255.255.255.0 172.16.0.6
ip route 10.1.60.0 255.255.255.0 172.16.0.6
ip route 10.0.255.0 255.255.255.0 172.16.0.6
!
ip route 192.168.0.0 255.255.255.252 172.16.0.1
ip route 192.168.8.0 255.255.255.252 172.16.0.6
ip route 192.168.12.0 255.255.255.252 172.16.0.6
!
!ACLs_IP
!
ip access-list extended ACL_VLAN30_IN
remark autorise dhcp client server
permit udp any eq 68 any eq 67
permit udp any eq 67 any eq 68
!
remark autorise ping pour vlans 10 20 30 50 60
permit icmp 10.1.30.0 0.0.0.255 10.1.10.0 0.0.0.255 echo
permit icmp 10.1.30.0 0.0.0.255 10.1.20.0 0.0.0.255 echo
permit icmp 10.1.30.0 0.0.0.255 10.1.30.0 0.0.0.255 echo
permit icmp 10.1.30.0 0.0.0.255 10.1.50.0 0.0.0.255 echo
permit icmp 10.1.30.0 0.0.0.255 10.1.60.0 0.0.0.255 echo
!
remark autorise reponse pour vlan 10 et 30
permit icmp 10.1.30.0 0.0.0.255 10.1.10.0 0.0.0.255 echo-reply
permit icmp 10.1.30.0 0.0.0.255 10.1.20.0 0.0.0.255 echo-reply
!
deny ip 10.1.30.0 0.0.0.255 10.1.40.0 0.0.0.255
deny ip 10.1.30.0 0.0.0.255 any
!
ip access-list standard SSH_VLAN40
permit 10.1.40.0 0.0.0.255
deny any any
!
ip domain-name azeez.local
username admin privilege 15 secret cr
crypto key generate rsa modulus 1024
ip ssh version 2
line vty 0 15
login local
transport input ssh
access-class SSH_VLAN40 in
!
end
!
wr

ena
conf t
hostname R2
!
interface gi0/1
description vers trunk sw-3
no ip address
no shut
!
interface gi0/0
description vers sw-4-serveurs
no ip address
no shutdown
!
interface gi0/1.50
encapsulation dot1q 50
ip address 10.1.50.254 255.255.255.0
ip access-group ACL_VLAN50_IN in
ip access-group ACL_VLAN50_OUT out
no shut
!
interface gi0/1.60
encapsulation dot1q 60
ip address 10.1.60.254 255.255.255.0
ip access-group ACL_VLAN60_IN in
ip access-group ACL_VLAN60_OUT out
no shut
!
interface gi0/1.666
encapsulation dot1q 666
ip address 192.168.0.9 255.255.255.252
no shut
!
interface gi0/0.255
encapsulation dot1q 255
ip address 10.1.0.254 255.255.255.252
no shutdown
!
interface gi0/0.666
encapsulation dot1q 666
ip address 192.168.0.13 255.255.255.252
no shut
!
interface gi0/2
description vers R1
ip address 172.16.0.6 255.255.255.252
no shutdown
!
ip route 10.1.10.0 255.255.255.0 172.16.0.5
ip route 10.1.20.0 255.255.255.0 172.16.0.5
ip route 10.1.30.0 255.255.255.0 172.16.0.5
ip route 10.1.40.0 255.255.255.0 172.16.0.5
!
ip route 192.168.0.0 255.255.255.252 172.16.0.5
ip route 192.168.0.4 255.255.255.252 172.16.0.5
!
!CONF ACL
!
ip access-list extended ACL_VLAN_50
!
remark autorise dhcp
permit udp any eq 68 any eq 67
permit udp any eq 67 any eq 68
!
remark autorise reponse ping
permit icmp 10.1.50.0 0.0.0.255 10.1.10.0 0.0.0.255 echo-reply
permit icmp 10.1.50.0 0.0.0.255 10.1.30.0 0.0.0.255 echo-reply
permit icmp 10.1.50.0 0.0.0.255 10.1.60.0 0.0.0.255 echo-reply
!
remark autorise connection vers nos deux serveurs
permit ip 10.1.50.0 0.0.0.255 host 10.0.255.10 0.0.0.255
permit ip 10.1.50.0 0.0.0.255 host 10.0.255.20 0.0.0.255
!
remark refuse tout autre connection apart les serveurs
deny ip 10.1.50.0 0.0.0.255 any
!
ip access-list extended ACL_VLAN_60
!
remark autorise dhcp
permit udp any eq 68 any eq 67
permit udp any eq 67 any eq 68
!
remark autorise requete ping
permit icmp 10.1.60.0 0.0.0.255 10.1.10.0 0.0.0.255 echo-reply
permit icmp 10.1.60.0 0.0.0.255 10.1.30.0 0.0.0.255 echo-reply
!
remark refuse connecter au appereil resaux
deny tcp 10.1.60.0 0.0.0.255 any eq 22
deny tcp 10.1.60.0 0.0.0.255 any eq 23
!
remark autorise tout
permit ip 10.1.60.0 0.0.0.255 any any
!
!CONF DHCP
!
ip dhcp pool vlan10
network 10.1.10.0 255.255.25.0
default-router 10.1.10.254
dns-server 10.0.255.20
domain-name azeez.local
!
ip dhcp pool vlan20
network 10.1.20.0 255.255.255.0
default-router 10.1.20.254
dns-server 10.0.255.20
domain-name azeez.local
!
ip dhcp pool vlan30
network 10.1.30.0 255.255.255.0
default-router 10.1.30.254
dns-server 10.0.255.20
domain-name azeez.local
!
ip dhcp pool vlan40
network 10.1.40.0 255.255.255.0
default-router 10.1.40.254
dns-server 10.0.255.20
domain-name azeez.local
!
ip dhcp pool vlan50
network 10.1.50.0 255.255.255.0
default-router 10.1.50.254
dns-server 10.0.255.20
domain-name azeez.local
!
ip dhcp pool vlan60
network 10.1.60.0 255.255.255.0
default-router 10.1.60.254
dns-server 10.0.255.60
domain-name azeez.local
!
ip access-list standard SSH_VLAN40
permit 10.1.40.0 0.0.0.255
deny any any
!
ip domain-name azeez.local
username admin privilege 15 secret cr
crypto key generate rsa modulus 1024
ip ssh version 2
line vty 0 15
login local
transport input ssh
access-class SSH_VLAN40 in
!
end
!
wr
==========================================================================================================================================================================================================================================================================================================================
Le VLAN 10 ne peut pas consulter les serveurs.
Le VLAN 10 peut envoyer des requêtes PING à tous les autres VLAN de PCs. (Tous les VLANs doivent répondre)
Le VLAN 20 peut seulement envoyer des requêtes PING au VLAN 30 et VLAN 60 (Les VLANs 30 et 60 doivent répondre)
Le VLAN 30 ne peut pas communiquer avec le VLAN 40
Le VLAN 30 peut envoyer des requêtes PING à tous les autres VLAN de PCs. (Tous les VLANs doivent répondre)
Le VLAN 40 est le seul à pouvoir se connecter à distance sur les équipements réseaux en SSH (pas de TELNET)
Le VLAN 50 peut uniquement communiquer avec les serveurs.
Le VLAN 60 peut tout faire, sauf se connecter aux appareils réseaux
=======================================================
=======================================================
=======================================================
```
