## Configuration Switch-1
```
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
switchport access vlan 20
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
```

## Configuration Switch-2
```
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
switchport access vlan 40
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
```

## Configuration Routeur 2
```
ena
conf t
hostname Routeur-2
!
router ospf 1
router-id 2.2.2.2
passive-interface default
no passive-interface gig1/0
no passive-interface fa3/0
no passive-interface gig0/0
no passive-interface eth6/0
!
network 192.168.0.28 0.0.0.3 area 0
network 192.168.0.24 0.0.0.3 area 0
network 192.168.0.8 0.0.0.3 area 0
!
network 10.0.0.0 0.0.0.3 area 0
network 10.0.1.0 0.0.0.3 area 0
!
interface gig1/0
no ip address
no shut
!
interface gig1/0.10
encapsulation dot1q 10
ip address 10.0.0.254 255.255.255.0
no shut
!
interface gig1/0.20
encapsulation dot1q 20
ip address 10.0.1.254 255.255.255.0
no shut
!
interface fa3/0
description vers R1
ip address 192.168.0.29 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface gig0/0
description vers R4
ip address 192.168.0.9 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface eth6/0
description vers R3
ip address 192.168.0.26 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
end
!
wr
```

## Configuration Routeur 1
```
ena
conf t
hostname Routeur-1
!
router ospf 1
router-id 1.1.1.1
passive-interface default
no passive-interface gig0/0
no passive-interface fa3/0
no passive-interface fa4/0
no passive-interface eth6/0
!
network 192.168.0.28 0.0.0.3 area 0
network 192.168.0.20 0.0.0.3 area 0
network 192.168.0.12 0.0.0.3 area 0
!
network 10.0.2.0 0.0.0.3 area 0
network 10.0.3.0 0.0.0.3 area 0
!
interface gig0/0
no ip address
no shut
!
interface gig0/0.30
encapsulation dot1q 30
ip address 10.0.2.254 255.255.255.0
no shut
!
interface gig0/0.40
encapsulation dot1q 40
ip address 10.0.3.254 255.255.255.0
no shut
!
interface fa3/0
description vers R2
ip address 192.168.0.30 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface fa4/0
description vers R3
ip address 192.168.0.22 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface eth6/0
description vers R4
ip address 192.168.0.14 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
end
!
wr
!
```
## Configuration Routeur 3
```
ena
conf t
hostname R3
!
router ospf 1
router-id 3.3.3.3
passive-interface default
no passive-interface fa3/0
no passive-interface fa4/0
no passive-interface fa5/0
no passive-interface eth6/0
!
network 192.168.0.24 0.0.0.3 area 0
network 192.168.0.20 0.0.0.3 area 0
network 192.168.0.16 0.0.0.3 area 0 
network 192.168.0.4 0.0.0.3 area 0
!
interface fa3/0
description vers R5
ip address 192.168.0.17 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface fa4/0
description vers R4
ip address 192.168.0.5 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface fa5/0
description vers R1
ip address 192.168.0.21 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface eth6/0
description vers R2
ip address 192.168.0.25 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
end
!
wr
```
## Configuration Routeur 4
```
ena
conf t
hostname Routeur-4
!
router ospf 1
router-id 4.4.4.4
passive-interface default
no passive-interface gig0/0
no passive-interface gig1/0
no passive-interface fa3/0
no passive-interface eth6/0
!
network 192.168.0.0 0.0.0.3 area 0
network 192.168.0.4 0.0.0.3 area 0
network 192.168.0.8 0.0.0.3 area 0
network 192.168.0.12 0.0.0.3 area 0
!
interface gig0/0
description vers R5
ip address 192.168.0.2 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface fa3/0
description vers R3
ip address 192.168.0.6 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface gig1/0
description vers R2
ip address 192.168.0.10 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface eth6/0
description vers R1
ip address 192.168.0.13 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
end
!
wr
```

## Configuration Routeur 5

ena
conf t
hostname Routeur-5
!
router ospf 1
router-id 5.5.5.5
passive-interface default
no passive-interface gig0/0
no passive-interface gig1/0
no passive-interface fa2/0
!
network 192.168.0.0 0.0.0.3 area 0
network 192.168.0.16 0.0.0.3 area 0
network 209.165.47.1 0.0.0.3 area 0
!
interface gig0/0
description vers R4
ip address 192.168.0.1 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface fa2/0
description vers R3
ip address 192.168.0.18 255.255.255.252
ip ospf hello-interval 5
ip ospf dead-interval 20
no shut
!
interface gig1/0
description vers Serveur-Internet
ip address 209.165.47.1 255.255.255.252
no shut
!
end
!
wr