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

```­­
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

# configuration site jaune

```­­
ena
conf t
hostname Switch2
!
vlan 20
!
vlan 21
!
interface FastEthernet0/1
description vlan20
switchport access vlan 20
switchport mode access
no shut
!
interface FastEthernet0/13
description vlan21
switchport access vlan 21
switchport mode access
no shut
!
interface GigabitEthernet0/1
description Trunk vers R1
switchport mode trunk
switchport trunk allowed vlan 20,21
no shut
!
end
!
wr
```

# Configurtion Routeur-2

```­
ena
conf t
hostname Routeur-2
!
router ospf 1
router-id 2.2.2.2
passive-interface default
no passive-interface fa1/0
no passive-interface eth0/0
no passive-interface gi2/0
no passive-interface gig5/0
!
network 10.0.0.4 0.0.0.3 area 0
network 10.0.0.12 0.0.0.3 area 0
network 10.0.0.16 0.0.0.3 area 0
!
network 192.168.20.0 0.0.0.255 area 0
network 192.168.21.0 0.0.0.255 area 0
!
interface gi2/0
no ip address
no shutdown
!
interface gi2/0.20
encapsulation dot1q 20
ip address 192.168.20.254 255.255.255.0
no shutdown
!
interface gi2/0.21
encapsulation dot1q 21
ip address 192.168.21.254 255.255.255.0
no shutdown
!
interface eth0/0
description vers routeur-2
ip address 10.0.0.6 255.255.255.252
no shutdown
!
interface fa1/0
description vers routeur-3
ip address 10.0.0.17 255.255.255.252
no shutdown
!
interface gi5/0
description vers routeur-4
ip address 10.0.0.13 255.255.255.252
no shutdown
!
end
!
wr
```

# configuration site mauve

```­
ena
conf t
hostname Switch3
!
vlan 30
!
vlan 31
!
interface FastEthernet0/1
description vlan30
switchport access vlan 30
switchport mode access
no shut
!
interface FastEthernet0/13
description vlan31
switchport access vlan 31
switchport mode access
no shut
!
interface GigabitEthernet0/1
description Trunk vers R3
switchport mode trunk
switchport trunk allowed vlan 30,31
no shut
!
end
!
wr
```

# Configurtion Routeur 3

```­­
ena
conf t
hostname Routeur-3
!
router ospf 1
router-id 3.3.3.3
passive-interface default
no passive-interface fa1/0
no passive-interface eth0/0
no passive-interface gi2/0
no passive-interface gig5/0
!
network 10.0.0.0 0.0.0.3 area 0
network 10.0.0.12 0.0.0.3 area 0
network 10.0.0.20 0.0.0.3 area 0
!
network 192.168.30.0 0.0.0.255 area 0
network 192.168.31.0 0.0.0.255 area 0
!
interface gi2/0
no ip address
no shutdown
!
interface gi2/0.20
encapsulation dot1q 20
ip address 192.168.20.254 255.255.255.0
no shutdown
!
interface gi2/0.31
encapsulation dot1q 31
ip address 192.168.31.254 255.255.255.0
no shutdown
!
interface fa1/0
description vers routeur-1
ip address 10.0.0.2 255.255.255.252
no shutdown
!
interface gi5/0
description vers routeur-2
ip address 10.0.0.14 255.255.255.252
no shutdown
!
interface eth0/0
description vers routeur-4
ip address 10.0.0.21 255.255.255.252
no shutdown
!
end
!
wr
```

# configuration site rouge

```­­
ena
conf t
hostname Switch4
!
vlan 40
!
vlan 41
!
interface FastEthernet0/1
description vlan40
switchport access vlan 40
switchport mode access
no shut
!
interface FastEthernet0/13
description vlan41
switchport access vlan 41
switchport mode access
no shut
!
interface GigabitEthernet0/1
description Trunk vers R1
switchport mode trunk
switchport trunk allowed vlan 40,41
no shut
!
end
!
wr
```

# Configurtion Routeur-4

```­­
ena
conf t
hostname Routeur-4
!
router ospf 1
router-id 4.4.4.4
passive-interface default
no passive-interface fa1/0
no passive-interface eth0/0
no passive-interface gi2/0
no passive-interface eth3/0
!
network 10.0.0.8 0.0.0.3 area 0
network 10.0.0.16 0.0.0.3 area 0
network 10.0.0.20 0.0.0.3 area 0
!
network 192.168.40.0 0.0.0.255 area 0
network 192.168.41.0 0.0.0.255 area 0
!
interface gi2/0
no ip address
no shutdown
!
interface gi2/0.40
encapsulation dot1q 40
ip address 192.168.40.254 255.255.255.0
no shutdown
!
interface gi2/0.41
encapsulation dot1q 41
ip address 192.168.41.254 255.255.255.0
no shutdown
!
interface eth3/0
description vers routeur-1
ip address 10.0.0.10 255.255.255.252
no shutdown
!
interface fa1/0
description vers routeur-2
ip address 10.0.0.18 255.255.255.252
no shutdown
!
interface eth0/0
description vers routeur-3
ip address 10.0.0.22 255.255.255.252
no shutdown
!
end
!
wr
```

