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
hostname sw-1
!
vlan 10
name vlan10
vlan 20
name vlan20
!
interface fa0/1
description vers PC-vlan10
switchport mode access
switchport access vlan 10
no shut
!
interface fa0/13
description vers PC-vlan20
switchport mode access
switchport access vlan 20
no shut
!
interface gi0/1
description vers Routeur-0
switchport mode trunk
switchport trunk allowed vlan 10,20
no shut
end
!
wr

=======================================================
=======================================================
=======================================================
ena
conf t
hostname sw-2
!
vlan 30
name vlan30
vlan 40
name vlan40
!
interface fa0/1
description vers PC-vlan30
switchport mode access
switchport access vlan 30
no shut
!
interface fa0/13
description vers PC-vlan40
switchport mode access
switchport access vlan 40
no shut
!
interface gi0/1
description vers Routeur-1
switchport mode trunk
switchport trunk allowed vlan 30,40
no shut
!
end
!
wr
=======================================================
=======================================================
=======================================================
ena
conf t
hostname sw-3
!
vlan 50
name vlan30
vlan 60
name vlan40
!
interface fa0/1
description vers PC-vlan50
switchport mode access
switchport access vlan 50
no shut
!
interface fa0/13
description vers PC-vlan60
switchport mode access
switchport access vlan 60
no shut
!
interface gi0/1
description vers Routeur-2
switchport mode trunk
switchport trunk allowed vlan 50,60
no shut
!
end
!
wr

=======================================================
=======================================================
=======================================================
ena
conf t
hostname sw-4
!
vlan 255
name vlan255
!
interface fa0/1
description vers SRV-DNS-vlan255
switchport mode access
switchport access vlan 255
no shut
!
interface fa0/2
description SRV-WEB-vlan255
switchport mode access
switchport access vlan 255
no shut
!
interface gi0/1
description vers Routeur-2
switchport mode trunk
switchport trunk allowed vlan 255
no shut
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
hostname Routeur-0
!
interface gig0/0
description vers Sw-1
no ip address
no shut
!
interface gig0/0.10
description vers Sw-1
encapsulation dot1q 10
ip address 10.1.10.254 255.255.255.0
ip access-group ACL_VLAN10 in
no shut
!
interface gig0/0.20
description vers Sw-1
encapsulation dot1q 20
ip address 10.1.20.254 255.255.255.0
ip access-group ACL_VLAN20 in
no shut
!
interface gig0/1
description vers Routeur-2
ip address 172.16.0.2 255.255.255.252
no shut
!
ip route 10.1.30.0 255.255.255.0 172.16.0.2
ip route 10.1.40.0 255.255.255.0 172.16.0.2
ip route 10.1.50.0 255.255.255.0 172.16.0.2
ip route 10.1.60.0 255.255.255.0 172.16.0.2
!
ip route srv
ip route srv
!
ip access-list extended ACL_VLAN10
Remark 
deny ip 10.1.10.0 0.0.0.255 10.0.255.20 0.0.0.255
deny ip 10.1.10.0 0.0.0.255 10.0.255.10 0.0.0.255
!
remark Autorise les requêtes PING (echo) du VLAN 10 vers les autres VLANs PC
permit icmp 10.1.10.0 0.0.0.255 10.1.10.0 0.0.0.255 echo
permit icmp 10.1.10.0 0.0.0.255 10.1.20.0 0.0.0.255 echo
permit icmp 10.1.10.0 0.0.0.255 10.1.30.0 0.0.0.255 echo
permit icmp 10.1.10.0 0.0.0.255 10.1.40.0 0.0.0.255 echo
permit icmp 10.1.10.0 0.0.0.255 10.1.50.0 0.0.0.255 echo
permit icmp 10.1.10.0 0.0.0.255 10.1.60.0 0.0.0.255 echo
!
remark Autorise les VLANs doivent répondre
permit icmp 10.1.10.0 0.0.0.255 10.1.10.0 0.0.0.255 echo-reply
permit icmp 10.1.20.0 0.0.0.255 10.1.10.0 0.0.0.255 echo-reply
permit icmp 10.1.30.0 0.0.0.255 10.1.10.0 0.0.0.255 echo-reply
permit icmp 10.1.40.0 0.0.0.255 10.1.10.0 0.0.0.255 echo-reply
permit icmp 10.1.50.0 0.0.0.255 10.1.10.0 0.0.0.255 echo-reply
permit icmp 10.1.60.0 0.0.0.255 10.1.10.0 0.0.0.255 echo-reply
!
remark deny ping vlan10 sur dautres reseux 
deny ip 10.1.10.0 0.0.0.255 any
!
ip access-list extended ACL-VLAN20
!
remark autorise vlan20 requêtes PING au VLAN 30 et 60
permit icmp 10.1.20.0 0.0.0.255 10.1.30.0 0.0.0.255 echo
permit icmp 10.1.20.0 0.0.0.255 10.1.60.0 0.0.0.255 echo
!
remark autorise vlan20 recoit les reponses requêtes PING du VLAN 30 et 60
permit icmp 10.1.30.0 0.0.0.255 10.1.20.0 0.0.0.255 echo-reply
permit icmp 10.1.60.0 0.0.0.255 10.1.20.0 0.0.0.255 echo-reply
!
deny ip 10.1.20.0 0.0.0.255 any
!
end
!
wr
=======================================================
=======================================================
=======================================================

ena
conf t
hostname routeur-1
!
interface gig0/0
description trunk-switch-2
no ip address
no shut
!
interface gig0/0.30
description vers trunk vlan30
encapsulation dot1q 30
ip access-group ACL_VLAN30 in
no shut
!
interface gig0/0.40
description vers trunk vlan40
encapsulation dot1q 40
ip access-group ACL_VLAN40 in
no shut
!
interface gig0/1
description vers SW-2
ip address 172.16.0.2 255.255.255.252
no shut
!
ip route 10.1.10.0 255.255.255.0 172.16.0.1
ip route 10.1.20.0 255.255.255.0 172.16.0.1
!
ip route 10.1.50.0 255.255.255.0 172.16.0.6
ip route 10.1.60.0 255.255.255.0 172.16.0.6
!
ip route srv
!
ip access-list extended ACL_VLAN30_in
remark VLAN 30 ne peut pas communiquer avec le VLAN 40
deny ip 10.1.30.0 0.0.0.255 10.1.40.0 0.0.0.255
! 
remark autorise VLAN 30 ne peut pas communiquer avec le VLAN 40 peut envoyer des requêtes PING à tous les autres VLAN de PCs
permit icmp 10.1.30.0 0.0.0.255 10.1.10.0 0.0.0.255 echo
permit icmp 10.1.30.0 0.0.0.255 10.1.20.0 0.0.0.255 echo
permit icmp 10.1.30.0 0.0.0.255 10.1.30.0 0.0.0.255 echo
permit icmp 10.1.30.0 0.0.0.255 10.1.50.0 0.0.0.255 echo
permit icmp 10.1.30.0 0.0.0.255 10.1.60.0 0.0.0.255 echo
!
remark autorise VLAN 30 peut envoyer des requêtes PING à tous les autres VLAN de PCs.
permit icmp 10.1.30.0 0.0.0.255 10.1.10.0 0.0.0.255 echo-reply
permit icmp 10.1.30.0 0.0.0.255 10.1.20.0 0.0.0.255 echo-reply
permit icmp 10.1.30.0 0.0.0.255 10.1.30.0 0.0.0.255 echo-reply
permit icmp 10.1.30.0 0.0.0.255 10.1.50.0 0.0.0.255 echo-reply
permit icmp 10.1.30.0 0.0.0.255 10.1.60.0 0.0.0.255 echo-reply
deny 10.1.30.0 0.0.0.255 any
!
in acess-list extended ACL_VLAN40
remark Le VLAN 40 est le seul à pouvoir se connecter à distance sur les équipements réseaux en SSH (pas de TELNET)
permit tcp 10.1.40.0 0.0.0.255 any eq 22
!
deny tcp 10.1.10.0 0.0.0.255 any eq 22
deny tcp 10.1.20.0 0.0.0.255 any eq 22
deny tcp 10.1.30.0 0.0.0.255 any eq 22
deny tcp 10.1.50.0 0.0.0.255 any eq 22
deny tcp 10.1.60.0 0.0.0.255 any eq 22
deny tcp 10.1.10.0 0.0.0.255 any eq 23
deny tcp 10.1.20.0 0.0.0.255 any eq 23
deny tcp 10.1.30.0 0.0.0.255 any eq 23
deny tcp 10.1.40.0 0.0.0.255 any eq 23
deny tcp 10.1.50.0 0.0.0.255 any eq 23
deny tcp 10.1.60.0 0.0.0.255 any eq 23
!
end
!
wr

ena
conf t
hostname routeur-2
!
interface fa




remark Le VLAN 50 peut uniquement communiquer avec les serveurs.
permit 10.1.50.0 0.0.0.255 10.0.225.0 0.0.0.255
deny ip any any

!
remark Le VLAN 60 peut tout faire, sauf se connecter aux appareils réseaux
deny tcp 10.1.60.0 0.0.0.255 eq 22
deny tcp 10.1.60.0 0.0.0.255 eq 23
permit ip any any
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