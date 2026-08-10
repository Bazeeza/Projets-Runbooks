# Projets-Runbooks

Recueil de **runbooks** techniques — procédures reproductibles étape par étape pour le déploiement, la configuration, la supervision et le dépannage d'infrastructures réseau et de services.

Chaque document présente le contexte, la topologie, les commandes exécutées et les résultats attendus, de façon à ce que la manipulation puisse être reproduite intégralement par un autre technicien.

---

## Contenu du dépôt

### `420-H63-RO SUPERVISION-RÉSEAUX-LOCAUX/`
**Architecture et supervision d'un réseau local sur équipements Cisco physiques**

- Configuration d'un routeur et d'un commutateur Cisco (IOS)
- Segmentation en **VLAN** (802.1Q) et trunking
- Serveur **DHCP** avec relais (`ip helper-address`)
- Traduction d'adresses **NAT** et accès Internet
- Supervision **SNMP v2c** pour l'inventaire et la collecte de métriques
- Tests de connectivité et procédures de dépannage

---

### `420-H34-RO UTILITAIRES-RÉSEAUX-AVANCÉS/`
**Supervision avancée avec Zabbix**

- Installation et configuration d'un serveur **Zabbix**
- Création de templates, d'items et de déclencheurs (triggers)
- Définition de seuils d'alerte (warning / critical) avec justification
- Collecte de métriques réseau et système

---

### `420-H66-RO POJET-SRV-INTERNET-3/`
**Services Internet et infrastructure cloud**

- Déploiement de services sur infrastructure AWS
- Supervision avec **CloudWatch** et analyse des résultats
- Configuration de serveurs Internet et validation des déploiements

---

### `420-H66-RO PROJETS-RÉSEAUTIQUE-2/`
**Notes de cours et travaux pratiques en réseautique**

- Concepts fondamentaux et références techniques
- Documentation de laboratoires réseau

---

### `MeshCentral/`
**Guide d'installation de MeshCentral sur Ubuntu**

Procédure complète de déploiement d'une solution libre de **gestion et de prise en main à distance** de postes de travail : installation, configuration du serveur, déploiement des agents et sécurisation de l'accès.

---

## Pourquoi des runbooks ?

Une infrastructure qu'on ne peut pas reconstruire n'est documentée qu'à moitié. Chaque runbook de ce dépôt vise trois objectifs :

1. **Reproductibilité** — un technicien peut refaire la manipulation sans connaissance préalable du contexte
2. **Traçabilité** — les commandes exactes et les résultats attendus sont consignés
3. **Transfert de connaissances** — la logique derrière chaque choix technique est expliquée, pas seulement la commande

---

## Technologies couvertes

**Réseau** — `Cisco IOS` · `VLAN 802.1Q` · `DHCP` · `NAT` · `TCP/IP` · `Routage et commutation`

**Supervision** — `Zabbix` · `SNMP v2c` · `AWS CloudWatch` · `Seuils et alertes`

**Systèmes et services** — `Ubuntu Server` · `MeshCentral` · `AWS`

---

## Compétences démontrées

- Configuration d'équipements réseau physiques (routeurs, commutateurs)
- Segmentation réseau et gestion des VLAN
- Mise en place de systèmes de supervision et d'alerte
- Déploiement de services sur Linux et sur le cloud
- Diagnostic et résolution de problèmes réseau
- Rédaction de documentation technique professionnelle

---

## Formation

Projets réalisés dans le cadre du **DEC en Techniques de l'informatique (Réseautique)** au Collège de Rosemont, Montréal.

---

## Auteur

**Abdul-Bariu Ishola Azeez**
Technicien en réseautique et télécommunication — Montréal, QC
Portfolio : [bazeeza.github.io](https://bazeeza.github.io) · GitHub : [@Bazeeza](https://github.com/Bazeeza)
