## Configuration Switch-1

ena
conf t
hostname switch-1
!
vlan 10
name PC-10
!
vlan 20
name pc-20
!
interface fa0/1
description vers PC-10
switchport mode access
switchport access vlan 10
no shutdown
!
interface fa0/13
description vers PC-20
switchport mode access
switchport acces vlan 20
no shut
!
interface gig0/1
description ver ROUTEUR-2
switchport mode trunk
switchport trunk allowed vlan 10,20
no shut
!
end
!
wr
!


## Configuration Switch-2

ena
conf t
hostname switch-2
!
vlan 30
name PC-30
!
vlan 40
name pc-40
!
interface fa0/1
description vers PC-30
switchport mode access
switchport access vlan 30
no shutdown
!
interface fa0/13
description vers PC-40
switchport mode access
switchport acces vlan 40
no shut
!
interface gig0/1
description ver ROUTEUR-1
switchport mode trunk
switchport trunk allowed vlan 30,40
no shut
!
end
!
wr
!


## Configuration Routeur 2

ena
conf t
hostname Routeur-2
!
routeur ospf 1
routeur id 2.2.2.2
passive-interface default
no passive-interface
!
network



