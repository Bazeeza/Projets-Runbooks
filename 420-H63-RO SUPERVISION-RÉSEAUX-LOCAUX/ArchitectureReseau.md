# Plan d'Architecture Réseau
Ce documentation présente la procédure de configuration pour mettre en place une architecture réseau qui a pour objectif de permettre un relais d'assignation d'adresses IP à partir d'un serveur DHCP.

## Préparation de l'environnement de travail et prérequis
Pour mettre en place ce réseau, assurez-vous d'avoir ces équipements reseau (Switch/Routeur) selon vos besions. Au moins;
   - Un Routeur Cisco Physique
   - Un Switch Cisco Physique

- Référence: Consultez la [Documentation du cour Serveurs de services Internet 1 (420H03RO - Automne 2024)](https://crosemont.moodle.decclic.qc.ca/course/view.php?id=5563&section=3)

## Attention !

La configuration qui vous a été fournie nécessite un câblage des équipements très spécifiques ! Assurez-vous de bien respecter les connexions suivantes :

- Le port `Ga 0/0` du routeur doit être connecté au switch.
- Le port `Ga 0/1` du routeur doit être connecté au port `LINK LOCAL` du réseau du département..
- Vos stations de travail peuvent utiliser n'importe quel autre port du commutateur.

## Procédure pour notre Routeur

1. Connectez-vous avec le port console sur votre routeur.
2. Saisissez `enable` puis `conf t` pour passer en mode de configuration.
   - Vous devriez voir afficher `Routeur( config )#`
3. Copiez et collez la configuration fournie ci-dessous dans votre session terminal et appuyez sur "enter".
4. Réinitialisation du routeur avant configuration:
   - Pour effacer la configuration actuelle, entrez les commandes suivantes :
     ```
     erase startup-config
     ```
   - Une fois la commande exécutée, rechargez le routeur pour appliquer les changements :
     ```
     reload
     ```

### Configuration du routeur

```
hostname Routeur
!
interface Embedded-Service-Engine0/0
!
interface GigabitEthernet0/0
 description Port connecte a votre switch
 ip address 192.168.5.1 255.255.255.0
 ip nat inside
 duplex auto
 speed auto
 no shut
!
interface GigabitEthernet0/1
 description Port connecte au reseau du departement
 ip address dhcp
 ip nat outside
 duplex auto
 speed auto
 no shut
!
access-list 1 permit any
ip nat inside source list 1 interface GigabitEthernet0/1 overload
!
end
!
```

## Sauvegarder la configuration :
- Pour sauvegarder la nouvelle configuration dans le fichier de démarrage, utilisez la commande suivante :
     ```
     copy running-config startup-config
     ```

## Procédure pour le Switch

1. Connexion au switch
    -Connectez-vous au switch via le port console.

2. Réinitialisation du Switch avant utilisation:
   - Pour effacer la configuration actuelle, entrez les commandes suivantes :
     ```
     erase startup-config
     ```
   - Une fois la commande exécutée, rechargez le routeur pour appliquer les changements :
     ```
     reload
     ```
---


## Modifications à Apporter Plus Tard sur Votre l'Infrastructure Réseau pour l'Inventaire SNMP des Équipements Physiques

Lorsque vous serez en mesure d'effectuer l'inventaire des équipements réseau physiques via SNMP, assurez-vous de configurer correctement le routeur et le switch pour qu'ils répondent aux requêtes SNMP.


#### Ajoutez ce configuration pour SNMP v2c (Routeur) :
```
snmp-server community Routeur-reseaux-locaux
snmp-server location E-305-rosemont
snmp-server contact equipe1
```

- **Le Switch nécessite une configuration supplémentaire sur la switch elle-meme, ainsi sur le Routeur. Pour réaliser son inventaire, il est nécessaire de lui attribuer une adresse IP spécifique.**

#### Ajoutez ce configuration pour SNMP v2c (Switch) :
```
snmp-server community Switch-reseaux-locaux
snmp-server location E-305-rosemont
snmp-server contact equipe1
```
#### Ajoutez ce configuration sur votre Switch

```
!
hostname Switch
!
interface vlan 2
 ip address 192.168.6.177 255.255.255.0
 no shutdown
!
ip default-gateway 192.168.6.1
! port GigabitEthernet0/1 connecté au routeur en mode trunk pour transporter les VLANs
interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk allowed vlan 1,2
 no shutdown
!
```
#### Ajoutez ce configuration sur votre Routeur

```
! Sous-interface pour le VLAN 2 (réseau 192.168.6.0/24)
interface GigabitEthernet0/0.2
 encapsulation dot1Q 2
 ip address 192.168.6.1 255.255.255.0
 ip nat inside
 no shutdown
!
interface GigabitEthernet0/1
 description Port connecte au reseau du departement
 ip address dhcp
 ip nat outside
 duplex auto
 speed auto
 no shutdown
!
access-list 1 permit any
!
ip nat inside source list 1 interface GigabitEthernet0/1 overload
!
ip route 0.0.0.0 0.0.0.0 GigabitEthernet0/1
!
end
```
--- 
## Sauvegarder la configuration :
- Pour sauvegarder la nouvelle configuration dans le fichier de démarrage, utilisez la commande suivante :
     ```
     copy running-config startup-config
     ```
