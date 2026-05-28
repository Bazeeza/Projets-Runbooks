# Samba - Partage de ficher

## Pourquoi Samba?

Nous avons pris Samba, puisqu'il est compaatible avec Windows et Linux, ce qui est ce que nous avons besoins pour faire ce partage entre notre VM WINDOWS CLIENT et VM UBUNTU SERVEUR
## Installation
Tout d'abord, il faut mettre à jour toute les packets installés

*image 1*
```
sudo apt update

```

On peut installer par la suite samba
---
![Image1](https://i.postimg.cc/YCNvS6R2/image1.png)
---

```
sudo apt install samba samba-common smbclient -y

```

### Configuration

Pour utiliser Samba, il faut configurer le fichier de configuration et mettre en place un utilisateur avec un répertoire pour le partage

On s'assure que Samba est belle et bien fonctionnelle

---
![Image2](https://i.postimg.cc/DwQSzr65/image2.png)
---
```
systemctl status smbd

```

Nous utilisons un utilisateur nommer samba avec le partage nommer partage
```
sudo useradd -m -d /samba/partage samba

```

Pour la configuration du fichier, il faut aller dans */etc/samba/smb.conf*
---
![Image3](https://i.postimg.cc/fR7VbcCC/image3.png)
---
```
/etc/samba/smb.conf

```

À la fin du fichier, il faut ajouter notre partage
```
[partage]
      path = /samba/partage
      valid users = samba
      browsable = yes
      read only = no
      guest ok = yes
```

---
![Image4](https://i.postimg.cc/bw0ZvxgR/image4.png)
---

Ici, **[partage]** est notre fichier de partage, il doit être le même associer lors du création de l'utilisateur samba.

**valid users** permet de laisser que certaines personnes au partage, dans notres cas, on laisse que samba.

**browsable = yes** et **read only = no** permet l'utilisateur samba et le client windows de voir le partage, ainsi de le modifier et supprimer des fichiers dans le partage.

**guest ok = yes** n'est pas néccesaire, mais s'il faut que nous mettons le partage ouvert pour tout le monde qui à access au server, on garde **guest ok** est on désactive la fonction **valid users**, puisqu'ils s'interferont

## Partage

En allant sur l'utilisateur samba, sous le répertoire **/samba/partage**, nous pouvous voir que le dossier partage et belle et bien là, avec les fichiers qui son aussi accessible par notre client Windows.

---
![Image5](https://i.postimg.cc/x1GXdv5R/image5.png)
---