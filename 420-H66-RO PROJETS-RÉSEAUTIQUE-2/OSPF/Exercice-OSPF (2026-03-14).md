# configuration site vert

```­­
ena
conf t
hostname Switch1
!
vlan 10
!
vlan 11
!
interface FastEthernet0/1
description vlan10
switchport access vlan 10
switchport mode access
no shut
!
interface FastEthernet0/13
description vlan11
switchport access vlan 11
switchport mode access
no shut
!
interface GigabitEthernet0/1
description Trunk vers R1
switchport mode trunk
switchport trunk allowed vlan 10,11
no shut
!
end
!
wr
```

# Configurtion Routeur-1 site-vert

```
ena
conf t
hostname Routeur-1
!
router ospf 1
router-id 1.1.1.1
passive-interface default
no passive-interface fa1/0
no passive-interface eth0/0
no passive-interface gi2/0
no passive-interface eth3/0
!
network 10.0.0.0 0.0.0.7 area 0
network 10.0.0.8 0.0.0.3 area 0
network 10.0.0.4 0.0.0.3 area 0
!
network 192.168.10.0 0.0.0.255 area 0
network 192.168.11.0 0.0.0.255 area 0
!
interface gig2/0
no ip address
no shutdown
!
interface gig2/0.10
encapsulation dot1q 10
ip address 192.168.10.254 255.255.255.0
ip 
no shutdown
!
interface gig2/0.11
encapsulation dot1q 11
ip address 192.168.11.254 255.255.255.0
no shutdown
!
interface eth3/0
description vers routeur-2
ip address 10.0.0.5 255.255.255.252
no shutdown
!
interface fa1/0
description vers routeur-3
ip address 10.0.0.1 255.255.255.252
no shutdown
!
interface eth0/0
description vers routeur-4
ip address 10.0.0.9 255.255.255.252
no shutdown
!
end
!
wr
```