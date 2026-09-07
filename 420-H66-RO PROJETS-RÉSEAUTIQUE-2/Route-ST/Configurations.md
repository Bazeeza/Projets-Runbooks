# Configurations des équipements

Configuration testée des quatre équipements du réseau redondant. Les commandes sont à coller directement dans la console de chaque appareil sous Cisco Packet Tracer.

**Ordre de saisie recommandé :** commutateur A → routeur A → commutateur niveau 3 B → routeur de secours.

---

## 1. Switch-BUILDING-A — Catalyst 2960-24TT

Commutateur d'accès du bâtiment A. Porte les deux VLAN utilisateurs et le lien trunk vers le routeur.

```cisco
ena
conf t
hostname Switch-BUILDING-A
!
vlan 10
 name PC-VLAN10
vlan 20
 name PC-VLAN20
!
interface fa0/1
 switchport mode access
 switchport access vlan 10
 no shutdown
!
interface fa0/13
 switchport mode access
 switchport access vlan 20
 no shutdown
!
interface gi0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20
 no shutdown
!
do wr
```

Le trunk n'autorise que les VLAN 10 et 20, ce qui limite le trafic transporté au strict nécessaire.

---

## 2. Router-BUILDING-A — ISR 2911

Routeur sur bâton du bâtiment A. Assure les passerelles des VLAN 10 et 20 et raccorde les deux liens de transit.

```cisco
ena
conf t
hostname Router-BUILDING-A
!
interface gi0/0
 no ip address
 no shutdown
!
interface gi0/0.10
 encapsulation dot1q 10
 ip address 192.168.10.254 255.255.255.0
 no shutdown
!
interface gi0/0.20
 encapsulation dot1q 20
 ip address 192.168.20.254 255.255.255.0
 no shutdown
!
interface gi0/1
 ip address 10.0.0.1 255.255.255.252
 no shutdown
!
interface gi0/2
 ip address 10.0.0.5 255.255.255.252
 no shutdown
!
! --- Routes principales vers le bâtiment B ---
ip route 172.16.110.0 255.255.255.0 10.0.0.2
ip route 172.16.120.0 255.255.255.0 10.0.0.2
!
! --- Routes de secours (distance 5) ---
ip route 172.16.110.0 255.255.255.0 10.0.0.6 5
ip route 172.16.120.0 255.255.255.0 10.0.0.6 5
!
! --- Réseau de transit non raccordé ---
ip route 10.0.0.8 255.255.255.252 10.0.0.2
ip route 10.0.0.8 255.255.255.252 10.0.0.6 5
!
do wr
```

L'interface physique `gi0/0` ne porte aucune adresse. Ce sont les sous-interfaces `.10` et `.20`, marquées en 802.1Q, qui servent de passerelles.

---

## 3. Router-Switch-BUILDING-B — Catalyst 3560

Commutateur multicouche du bâtiment B. Assure le routage inter-VLAN et remplace un routeur classique.

```cisco
ena
conf t
hostname Router-Switch-BUILDING-B
ip routing
!
vlan 110
 name PC-VLAN110
vlan 120
 name PC-VLAN120
!
interface fa0/1
 switchport mode access
 switchport access vlan 110
 no shutdown
!
interface fa0/13
 switchport mode access
 switchport access vlan 120
 no shutdown
!
interface vlan 110
 ip address 172.16.110.254 255.255.255.0
 no shutdown
!
interface vlan 120
 ip address 172.16.120.254 255.255.255.0
 no shutdown
!
! --- Ports routés (no switchport AVANT ip address) ---
interface gi0/1
 no switchport
 ip address 10.0.0.2 255.255.255.252
 no shutdown
!
interface gi0/2
 no switchport
 ip address 10.0.0.9 255.255.255.252
 no shutdown
!
! --- Routes principales vers le bâtiment A ---
ip route 192.168.10.0 255.255.255.0 10.0.0.1
ip route 192.168.20.0 255.255.255.0 10.0.0.1
!
! --- Routes de secours (distance 5) ---
ip route 192.168.10.0 255.255.255.0 10.0.0.10 5
ip route 192.168.20.0 255.255.255.0 10.0.0.10 5
!
! --- Réseau de transit non raccordé ---
ip route 10.0.0.4 255.255.255.252 10.0.0.1
ip route 10.0.0.4 255.255.255.252 10.0.0.10 5
!
do wr
```

Deux commandes conditionnent tout le fonctionnement de cet équipement : `ip routing`, sans laquelle il reste un simple commutateur de niveau 2, et `no switchport`, qui doit précéder `ip address` sur les ports `gi0/1` et `gi0/2`.

---

## 4. Router-Secours — ISR 1941

Routeur de secours. Ne transporte aucun trafic tant que le lien principal 10.0.0.0/30 est debout.

```cisco
ena
conf t
hostname Router-Secours
!
interface gi0/0
 ip address 10.0.0.6 255.255.255.252
 no shutdown
!
interface gi0/1
 ip address 10.0.0.10 255.255.255.252
 no shutdown
!
! --- Routes vers le bâtiment A ---
ip route 192.168.10.0 255.255.255.0 10.0.0.5
ip route 192.168.20.0 255.255.255.0 10.0.0.5
ip route 192.168.10.0 255.255.255.0 10.0.0.9 5
ip route 192.168.20.0 255.255.255.0 10.0.0.9 5
!
! --- Routes vers le bâtiment B ---
ip route 172.16.110.0 255.255.255.0 10.0.0.9
ip route 172.16.120.0 255.255.255.0 10.0.0.9
ip route 172.16.110.0 255.255.255.0 10.0.0.5 5
ip route 172.16.120.0 255.255.255.0 10.0.0.5 5
!
! --- Réseau de transit non raccordé ---
ip route 10.0.0.0 255.255.255.252 10.0.0.5
ip route 10.0.0.0 255.255.255.252 10.0.0.9 5
!
do wr
```

> **Correction apportée.** La dernière ligne visait initialement `10.0.0.8 255.255.255.252 10.0.0.9 5`. Or `10.0.0.8/30` est directement raccordé à cet équipement par `gi0/1`, et un réseau connecté (distance 0) l'emporte toujours sur une route statique. La route était donc ignorée, et le secours vers `10.0.0.0/30` n'existait pas. Le réseau visé est bien `10.0.0.0/30`.

---

## Récapitulatif des routes

| Équipement | Destination | Prochain saut | Distance | Rôle |
|---|---|---|---|---|
| Router-BUILDING-A | 172.16.110.0/24 | 10.0.0.2 | 1 | Principal |
| Router-BUILDING-A | 172.16.120.0/24 | 10.0.0.2 | 1 | Principal |
| Router-BUILDING-A | 172.16.110.0/24 | 10.0.0.6 | 5 | Secours |
| Router-BUILDING-A | 172.16.120.0/24 | 10.0.0.6 | 5 | Secours |
| Router-BUILDING-A | 10.0.0.8/30 | 10.0.0.2 / 10.0.0.6 | 1 / 5 | Transit |
| Router-Switch-BUILDING-B | 192.168.10.0/24 | 10.0.0.1 | 1 | Principal |
| Router-Switch-BUILDING-B | 192.168.20.0/24 | 10.0.0.1 | 1 | Principal |
| Router-Switch-BUILDING-B | 192.168.10.0/24 | 10.0.0.10 | 5 | Secours |
| Router-Switch-BUILDING-B | 192.168.20.0/24 | 10.0.0.10 | 5 | Secours |
| Router-Switch-BUILDING-B | 10.0.0.4/30 | 10.0.0.1 / 10.0.0.10 | 1 / 5 | Transit |
| Router-Secours | 192.168.10.0/24 | 10.0.0.5 / 10.0.0.9 | 1 / 5 | Vers bâtiment A |
| Router-Secours | 192.168.20.0/24 | 10.0.0.5 / 10.0.0.9 | 1 / 5 | Vers bâtiment A |
| Router-Secours | 172.16.110.0/24 | 10.0.0.9 / 10.0.0.5 | 1 / 5 | Vers bâtiment B |
| Router-Secours | 172.16.120.0/24 | 10.0.0.9 / 10.0.0.5 | 1 / 5 | Vers bâtiment B |
| Router-Secours | 10.0.0.0/30 | 10.0.0.5 / 10.0.0.9 | 1 / 5 | Transit |

---

## Vérification après saisie

Sur `Router-Switch-BUILDING-B`, contrôler que les deux ports routés ont bien pris leur adresse :

```cisco
show ip interface brief | include 10.0.0
```

Les interfaces `GigabitEthernet0/1` et `GigabitEthernet0/2` doivent apparaître en `up / up`. Si elles n'ont pas d'adresse, la commande `no switchport` a été refusée ou omise.

Sur chaque équipement, vérifier la table de routage :

```cisco
show ip route static
```

Seules les routes de distance 1 doivent apparaître, sous la forme `[1/0]`. Les routes flottantes restent invisibles tant que le chemin principal fonctionne — c'est le comportement attendu.

Depuis `PC-VLAN10`, tester la connectivité complète :

```
ping 172.16.110.10
ping 172.16.120.10
ping 10.0.0.9
ping 10.0.0.10
```

Enfin, supprimer le câble entre `Router-BUILDING-A` gi0/1 et `Router-Switch-BUILDING-B` gi0/1, patienter une dizaine de secondes, puis relancer `show ip route static` : les routes doivent afficher `[5/0]`. Un `tracert 172.16.110.10` depuis `PC-VLAN10` doit passer par 10.0.0.6 puis 10.0.0.10.
