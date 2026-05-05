
# Configuration SW-A

```
ena
conf t
hostname SW-A
!
vlan 10
name VLAN10
!
vlan 20
name VLAN20
!
interface fa0/1
description vers PC-VLAN10
switchport mode access
switchport access vlan 10
no shutdown
!
interface fa0/13
description vers PC-VLAN20
switchport mode access
switchport access vlan 20
no shutdown
!
interface gig0/1
description vers RT-4
switchport mode trunk
switchport trunk allowed vlan 10,20
no shutdown
!
end
!
wr
!
```

---

# Configuration SW-B

```
ena
conf t
hostname SW-B
!
vlan 30
name VLAN30
!
vlan 40
name VLAN40
!
interface fa0/1
description vers PC-VLAN30
switchport mode access
switchport access vlan 30
no shutdown
!
interface fa0/13
description vers PC-VLAN40
switchport mode access
switchport access vlan 40
no shutdown
!
interface gig0/1
description vers RT-3
switchport mode trunk
switchport trunk allowed vlan 30,40
no shutdown
!
end
!
wr
!
```

---

# Configuration RT-4

```
ena
conf t
hostname RT-4
!
interface gig0/0
no shutdown
!
interface gig0/0.10
encapsulation dot1q 10
ip address 192.168.64.254 255.255.255.0
!
interface gig0/0.20
encapsulation dot1q 20
ip address 192.168.65.254 255.255.255.0
!
interface fa3/0
description vers RT-3
ip address 10.23.45.17 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface eth6/0
description vers RT-1
ip address 10.23.45.13 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface eth7/0
description vers RT-2
ip address 10.23.45.9 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
router ospf 10
router-id 1.1.1.1
passive-interface gig0/0.10
passive-interface gig0/0.20
network 192.168.64.0 0.0.1.255 area 0
network 10.23.45.8 0.0.0.7 area 0
network 10.23.45.16 0.0.0.3 area 0
!
end
!
wr
!
```

---

# Configuration RT-3

```
ena
conf t
hostname RT-3
!
interface gig0/0
no shutdown
!
interface gig0/0.30
encapsulation dot1q 30
ip address 192.168.66.254 255.255.255.0
!
interface gig0/0.40
encapsulation dot1q 40
ip address 192.168.67.254 255.255.255.0
!
interface gig1/0
description vers RT-2
ip address 10.23.45.1 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface fa3/0
description vers RT-1
ip address 10.23.45.21 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface fa4/0
description vers RT-4
ip address 10.23.45.18 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
router ospf 10
router-id 2.2.2.2
passive-interface gig0/0.30
passive-interface gig0/0.40
network 192.168.66.0 0.0.1.255 area 0
network 10.23.45.0 0.0.0.3 area 0
network 10.23.45.16 0.0.0.7 area 0
!
end
!
wr
!
```

---

# Configuration RT-2

```
ena
conf t
hostname RT-2
!
interface gig0/0
description vers RT-FRONT
ip address 10.23.45.30 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface gig1/0
description vers RT-3
ip address 10.23.45.2 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface eth6/0
description vers RT-1
ip address 10.23.45.6 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface eth7/0
description vers RT-4
ip address 10.23.45.10 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
router ospf 10
router-id 3.3.3.3
network 10.23.45.0 0.0.0.7 area 0
network 10.23.45.8 0.0.0.3 area 0
network 10.23.45.28 0.0.0.3 area 0
!
end
!
wr
!
```

---

# Configuration RT-1

```
ena
conf t
hostname RT-1
!
interface fa3/0
description vers RT-FRONT
ip address 10.23.45.25 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface fa4/0
description vers RT-3
ip address 10.23.45.22 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface eth6/0
description vers RT-2
ip address 10.23.45.5 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface eth7/0
description vers RT-4
ip address 10.23.45.14 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
router ospf 10
router-id 4.4.4.4
network 10.23.45.4 0.0.0.3 area 0
network 10.23.45.12 0.0.0.3 area 0
network 10.23.45.20 0.0.0.3 area 0
network 10.23.45.24 0.0.0.3 area 0
!
end
!
wr
!
```

---

# Configuration RT-FRONT

```
ena
conf t
hostname RT-FRONT
!
interface gig0/0
description INTERNET
ip address 144.36.77.15 255.255.255.0
no shutdown
!
interface gig1/0
description vers RT-2
ip address 10.23.45.29 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
interface fa2/0
description vers RT-1
ip address 10.23.45.26 255.255.255.252
ip ospf hello-interval 3
ip ospf dead-interval 12
no shutdown
!
ip route 0.0.0.0 0.0.0.0 gig0/0
!
router ospf 10
router-id 5.5.5.5
passive-interface gig0/0
network 10.23.45.24 0.0.0.7 area 0
default-information originate
!
end
!
wr
!
```

---
