#######################################################################################
#!/bin/bash
# AzeezScriptLinux.sh
# Nom : Abdul-Bariu Ishola Azeez
# But    : Vérifier et corriger quelques règles CIS sur Ubuntu 24.04
#          à partir d'un fichier XML passé avec -f (nom du fichier).
#          Le contenu du XML sert comme "config", mais ici on applique
#          directement les valeurs recommandées par le CIS.
# Récepteur : M. Gilles Lacasse
#######################################################################################
#######################################################################################

# Init des variables 
Azeez_ModeValidation=0 
Azeez_ModeCorrection=0   # 1 = on essaie de corriger
Azeez_ModeSilence=0      # 1 = -q, on cache les lignes OK à l'écran
Azeez_ModeDouble=0       # 1 = -2, écran + fichier
Azeez_FichierXML=""      # passé avec -f
Azeez_FichierSortie=""   # passé avec -s
Azeez_Lines=()           # tableau pour écrire dans le fichier

#  petite fonction pour erreurs simples 
Azeez_Erreur() {
    echo "[Azeez-ERREUR] $1" >&2
}

#  parser les arguments 
while [ $# -gt 0 ]; do
    case "$1" in
        -f)
            Azeez_FichierXML="$2"
            shift 2
            ;;
        -v)
            Azeez_ModeValidation=1
            shift
            ;;
        -c)
            Azeez_ModeCorrection=1
            shift
            ;;
        -q)
            Azeez_ModeSilence=1
            shift
            ;;
        -s)
            Azeez_FichierSortie="$2"
            shift 2
            ;;
        -2)
            Azeez_ModeDouble=1
            shift
            ;;
        *)
            Azeez_Erreur "Option inconnue : $1"
            exit 1
            ;;
    esac
done

#  vérifications de base 

# -f obligatoire
if [ -z "$Azeez_FichierXML" ]; then
    Azeez_Erreur "L'option -f <fichier.xml> est obligatoire."
    exit 1
fi

# fichier XML doit exister
if [ ! -f "$Azeez_FichierXML" ]; then
    Azeez_Erreur "Le fichier XML '$Azeez_FichierXML' n'existe pas."
    exit 1
fi

# si ni -v ni -c -> on fait au moins la validation
if [ "$Azeez_ModeValidation" -eq 0 ] && [ "$Azeez_ModeCorrection" -eq 0 ]; then
    Azeez_ModeValidation=1
fi

# -2 sans -s -> pas permis
if [ "$Azeez_ModeDouble" -eq 1 ] && [ -z "$Azeez_FichierSortie" ]; then
    Azeez_Erreur "L'option -2 doit être utilisée avec -s <fichier_sortie>."
    exit 1
fi

#  fonction pour ajouter une ligne de résultat 
# param 1 : message à afficher
# param 2 : 1 = OK / 0 = problème
Azeez_AjouterLigne() {
    local texte="$1"
    local est_ok="$2"   # "1" = conforme, "0" = problème

    # On met toujours la ligne dans le tableau si on a -s
    if [ -n "$Azeez_FichierSortie" ]; then
        Azeez_Lines+=("$texte")
    fi

    # Faut-il afficher à l'écran ?
    # - si pas de -s -> on montre toujours
    # - si -s mais pas -2 -> on ne montre pas
    # - si -s et -2 -> on montre aussi
    local doit_afficher=0
    if [ -z "$Azeez_FichierSortie" ]; then
        doit_afficher=1
    else
        if [ "$Azeez_ModeDouble" -eq 1 ]; then
            doit_afficher=1
        fi
    fi

    if [ "$doit_afficher" -eq 1 ]; then
        # mode -q : on montre juste les lignes non conformes
        if [ "$Azeez_ModeSilence" -eq 1 ] && [ "$est_ok" = "1" ]; then
            return
        fi
        echo "$texte"
    fi
}

#  petit helper pour savoir si on peut corriger 
Azeez_PeutCorriger() {
    # 1 = oui si -c
    if [ "$Azeez_ModeCorrection" -eq 1 ]; then
        return 0
    else
        return 1
    fi
}

#  Fonctions de tests pour chaque règle CIS demandée
#  (les valeurs attendues sont celles du benchmark Ubuntu 24.04 L1)

# 2.2.4 – telnet client non installé
Azeez_Test_Telnet() {
    local pkg="telnet"
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[PKG][CIS-2.2.4-TELNET] '$pkg' installé -> suppression par Azeez..." 0
            apt-get -y remove "$pkg" >/dev/null 2>&1
        else
            Azeez_AjouterLigne "[PKG][CIS-2.2.4-TELNET] '$pkg' installé (NON conforme, devrait être absent)." 0
        fi
    else
        Azeez_AjouterLigne "[PKG][CIS-2.2.4-TELNET] '$pkg' non installé (conforme)." 1
    fi
}

# 2.2.6 – ftp client non installé
Azeez_Test_Ftp() {
    local pkg="ftp"
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[PKG][CIS-2.2.6-FTP] '$pkg' installé -> suppression par Azeez..." 0
            apt-get -y remove "$pkg" >/dev/null 2>&1
        else
            Azeez_AjouterLigne "[PKG][CIS-2.2.6-FTP] '$pkg' installé (NON conforme, devrait être absent)." 0
        fi
    else
        Azeez_AjouterLigne "[PKG][CIS-2.2.6-FTP] '$pkg' non installé (conforme)." 1
    fi
}

# 3.3.1 – ip forwarding désactivé
Azeez_Test_IpForward() {
    local val
    val=$(sysctl -n net.ipv4.ip_forward 2>/dev/null || echo "inconnu")
    if [ "$val" = "0" ]; then
        Azeez_AjouterLigne "[SYSCTL][CIS-3.3.1-IPFWD] net.ipv4.ip_forward=0 (OK, attendu=0)." 1
    else
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[SYSCTL][CIS-3.3.1-IPFWD] net.ipv4.ip_forward=$val (NON conforme, réglage à 0 par Azeez)." 0
            sysctl -w net.ipv4.ip_forward=0 >/dev/null 2>&1
            # on force dans un fichier sysctl.d simple
            echo "net.ipv4.ip_forward = 0" >/etc/sysctl.d/99-azeez-ipforward.conf 2>/dev/null
            sysctl -p /etc/sysctl.d/99-azeez-ipforward.conf >/dev/null 2>&1
        else
            Azeez_AjouterLigne "[SYSCTL][CIS-3.3.1-IPFWD] net.ipv4.ip_forward=$val (NON conforme, attendu=0)." 0
        fi
    fi
}

# 4.1.1 – un seul firewall
Azeez_Test_UnSeulFirewall() {
    local a b c n
    dpkg -s ufw >/dev/null 2>&1
    a=$?
    dpkg -s firewalld >/dev/null 2>&1
    b=$?
    dpkg -s nftables >/dev/null 2>&1
    c=$?
    n=0
    [ $a -eq 0 ] && n=$((n+1))
    [ $b -eq 0 ] && n=$((n+1))
    [ $c -eq 0 ] && n=$((n+1))

    if [ "$n" -le 1 ]; then
        Azeez_AjouterLigne "[FW][CIS-4.1.1-FW-ONLYONE] au plus un firewall installé (ufw=$([ $a -eq 0 ] && echo 1 || echo 0), firewalld=$([ $b -eq 0 ] && echo 1 || echo 0), nftables=$([ $c -eq 0 ] && echo 1 || echo 0))." 1
    else
        Azeez_AjouterLigne "[FW][CIS-4.1.1-FW-ONLYONE] plusieurs firewalls en même temps (ufw=$([ $a -eq 0 ] && echo 1 || echo 0), firewalld=$([ $b -eq 0 ] && echo 1 || echo 0), nftables=$([ $c -eq 0 ] && echo 1 || echo 0)). À corriger manuellement." 0
    fi
}

# 4.2.1 – ufw installé
Azeez_Test_UfwInstalle() {
    if dpkg -s ufw >/dev/null 2>&1; then
        Azeez_AjouterLigne "[PKG][CIS-4.2.1-UFW-INSTALLED] 'ufw' présent (conforme)." 1
    else
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[PKG][CIS-4.2.1-UFW-INSTALLED] 'ufw' absent, installation par Azeez..." 0
            apt-get -y install ufw >/dev/null 2>&1
        else
            Azeez_AjouterLigne "[PKG][CIS-4.2.1-UFW-INSTALLED] 'ufw' absent (NON conforme)." 0
        fi
    fi
}

# 4.2.3 – ufw service enabled
Azeez_Test_UfwEnabled() {
    local status
    status=$(ufw status 2>/dev/null | grep -i "^Status" | awk '{print $2}')
    if [ "$status" = "active" ]; then
        Azeez_AjouterLigne "[UFW][CIS-4.2.3-UFW-ENABLED] ufw actif (Status=$status)." 1
    else
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[UFW][CIS-4.2.3-UFW-ENABLED] ufw pas actif, activation par Azeez..." 0
            ufw --force enable >/dev/null 2>&1
        else
            Azeez_AjouterLigne "[UFW][CIS-4.2.3-UFW-ENABLED] ufw pas actif (Status=$status)." 0
        fi
    fi
}

# lecture simple de /etc/login.defs
Azeez_LireLoginDefs() {
    local cle="$1"
    awk -v k="$cle" '
        $1 == k {print $2}
    ' /etc/login.defs 2>/dev/null | tail -n 1
}

Azeez_SetLoginDefs() {
    local cle="$1"
    local val="$2"
    if grep -qE "^[[:space:]]*$cle" /etc/login.defs 2>/dev/null; then
        sed -i "s/^[[:space:]]*$cle.*/$cle    $val/" /etc/login.defs 2>/dev/null
    else
        echo "$cle    $val" >> /etc/login.defs 2>/dev/null
    fi
}

# 5.4.1.1 – PASS_MAX_DAYS = 90
Azeez_Test_PassMaxDays() {
    local attendu=90
    local actuel
    actuel=$(Azeez_LireLoginDefs "PASS_MAX_DAYS")
    if [ -z "$actuel" ]; then
        actuel="non défini"
    fi

    if [ "$actuel" = "$attendu" ]; then
        Azeez_AjouterLigne "[LOGIN.DEFS][CIS-5.4.1.1-PASS-MAX] PASS_MAX_DAYS=$actuel (OK, attendu=$attendu)." 1
    else
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[LOGIN.DEFS][CIS-5.4.1.1-PASS-MAX] PASS_MAX_DAYS=$actuel (NON conforme, mise à $attendu par Azeez)." 0
            Azeez_SetLoginDefs "PASS_MAX_DAYS" "$attendu"
        else
            Azeez_AjouterLigne "[LOGIN.DEFS][CIS-5.4.1.1-PASS-MAX] PASS_MAX_DAYS=$actuel (NON conforme, attendu=$attendu)." 0
        fi
    fi
}

# 5.4.1.3 – PASS_WARN_AGE = 7
Azeez_Test_PassWarnAge() {
    local attendu=7
    local actuel
    actuel=$(Azeez_LireLoginDefs "PASS_WARN_AGE")
    if [ -z "$actuel" ]; then
        actuel="non défini"
    fi

    if [ "$actuel" = "$attendu" ]; then
        Azeez_AjouterLigne "[LOGIN.DEFS][CIS-5.4.1.3-PASS-WARN] PASS_WARN_AGE=$actuel (OK, attendu=$attendu)." 1
    else
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[LOGIN.DEFS][CIS-5.4.1.3-PASS-WARN] PASS_WARN_AGE=$actuel (NON conforme, mise à $attendu par Azeez)." 0
            Azeez_SetLoginDefs "PASS_WARN_AGE" "$attendu"
        else
            Azeez_AjouterLigne "[LOGIN.DEFS][CIS-5.4.1.3-PASS-WARN] PASS_WARN_AGE=$actuel (NON conforme, attendu=$attendu)." 0
        fi
    fi
}

# 5.4.1.4 – yescrypt dans pam_unix
Azeez_Test_PasswordHash() {
    if grep -Eq "pam_unix\.so.*yescrypt" /etc/pam.d/common-password 2>/dev/null; then
        Azeez_AjouterLigne "[PAM][CIS-5.4.1.4-PASS-HASH] pam_unix utilise yescrypt (OK)." 1
    else
        Azeez_AjouterLigne "[PAM][CIS-5.4.1.4-PASS-HASH] pam_unix n'utilise pas yescrypt (NON conforme, à corriger manuellement)." 0
    fi
}

# 5.4.1.5 – INACTIVE=30 dans /etc/default/useradd
Azeez_Test_UseraddInactive() {
    local attendu=30
    local actuel
    actuel=$(grep -E "^INACTIVE=" /etc/default/useradd 2>/dev/null | head -n1 | cut -d'=' -f2)
    if [ -z "$actuel" ]; then
        actuel="non défini"
    fi

    if [ "$actuel" = "$attendu" ]; then
        Azeez_AjouterLigne "[USERADD][CIS-5.4.1.5-INACTIVE] INACTIVE=$actuel (OK, attendu=$attendu)." 1
    else
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[USERADD][CIS-5.4.1.5-INACTIVE] INACTIVE=$actuel (NON conforme, mise à $attendu par Azeez)." 0
            if grep -qE "^INACTIVE=" /etc/default/useradd 2>/dev/null; then
                sed -i "s/^INACTIVE=.*/INACTIVE=$attendu/" /etc/default/useradd 2>/dev/null
            else
                echo "INACTIVE=$attendu" >> /etc/default/useradd 2>/dev/null
            fi
        else
            Azeez_AjouterLigne "[USERADD][CIS-5.4.1.5-INACTIVE] INACTIVE=$actuel (NON conforme, attendu=$attendu)." 0
        fi
    fi
}

# 5.4.1.6 – last password change dans le passé
Azeez_Test_LastChange() {
    if [ ! -r /etc/shadow ]; then
        Azeez_AjouterLigne "[LASTCHANGE][CIS-5.4.1.6-LASTCHANGE] pas accès à /etc/shadow (lancer avec sudo pour ce test)." 0
        return
    fi

    local probleme=0
    while IFS=: read -r user pass lastchange rest; do
        # si compte verrouillé ou sans mot de passe, on skip
        if [[ "$pass" =~ ^(!|[*]) ]]; then
            continue
        fi
        if [ -z "$lastchange" ] || [ "$lastchange" = "99999" ] || [ "$lastchange" = "0" ]; then
            probleme=1
            break
        fi
    done < /etc/shadow

    if [ $probleme -eq 0 ]; then
        Azeez_AjouterLigne "[LASTCHANGE][CIS-5.4.1.6-LASTCHANGE] tous les comptes ont une date de changement (pas 'never')." 1
    else
        Azeez_AjouterLigne "[LASTCHANGE][CIS-5.4.1.6-LASTCHANGE] au moins un compte avec date de changement invalide." 0
    fi
}

# 5.4.2.1 – root seul UID 0
Azeez_Test_UID0() {
    local count
    count=$(awk -F: '$3 == 0 {print $1}' /etc/passwd | wc -l)
    if [ "$count" -eq 1 ]; then
        Azeez_AjouterLigne "[ROOT][CIS-5.4.2.1-UID0] root est le seul UID 0." 1
    else
        Azeez_AjouterLigne "[ROOT][CIS-5.4.2.1-UID0] plusieurs comptes avec UID 0 (NON conforme)." 0
    fi
}

# 5.4.2.2 – root seul GID 0
Azeez_Test_GID0() {
    local count
    count=$(awk -F: '$4 == 0 {print $1}' /etc/passwd | wc -l)
    if [ "$count" -eq 1 ]; then
        Azeez_AjouterLigne "[ROOT][CIS-5.4.2.2-GID0] root est le seul GID 0." 1
    else
        Azeez_AjouterLigne "[ROOT][CIS-5.4.2.2-GID0] plusieurs comptes avec GID 0 (NON conforme)." 0
    fi
}

# 5.4.2.4 – root SSH contrôlé
Azeez_Test_RootSSH() {
    local fichier="/etc/ssh/sshd_config"
    local attendu="no"
    local courant

    if [ ! -f "$fichier" ]; then
        Azeez_AjouterLigne "[ROOT-SSH][CIS-5.4.2.4-ROOT-SSH] fichier $fichier manquant." 0
        return
    fi

    courant=$(grep -iE "^[[:space:]]*PermitRootLogin" "$fichier" 2>/dev/null | tail -n1 | awk '{print $2}')
    if [ -z "$courant" ]; then
        courant="non défini"
    fi

    if [ "$courant" = "$attendu" ]; then
        Azeez_AjouterLigne "[ROOT-SSH][CIS-5.4.2.4-ROOT-SSH] PermitRootLogin=$courant (OK, attendu=$attendu)." 1
    else
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[ROOT-SSH][CIS-5.4.2.4-ROOT-SSH] PermitRootLogin=$courant (NON conforme, mise à $attendu par Azeez)." 0
            if grep -qiE "^[[:space:]]*PermitRootLogin" "$fichier"; then
                sed -i "s/^[[:space:]]*PermitRootLogin.*/PermitRootLogin $attendu/i" "$fichier"
            else
                echo "PermitRootLogin $attendu" >> "$fichier"
            fi
            systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null
        else
            Azeez_AjouterLigne "[ROOT-SSH][CIS-5.4.2.4-ROOT-SSH] PermitRootLogin=$courant (NON conforme, attendu=$attendu)." 0
        fi
    fi
}

# 5.4.2.7 – comptes système sans shell interactif
Azeez_Test_SystemAccountsShell() {
    local probleme=0
    while IFS=: read -r user pass uid gid desc home shell; do
        if [ "$uid" -ge 1000 ]; then
            continue
        fi
        if [ "$user" = "root" ]; then
            continue
        fi
        case "$shell" in
            /usr/sbin/nologin|/bin/false|"")
                ;;
            *)
                probleme=1
                break
                ;;
        esac
    done < /etc/passwd

    if [ $probleme -eq 0 ]; then
        Azeez_AjouterLigne "[SYS-ACCOUNTS][CIS-5.4.2.7-SYS-SHELL] comptes système ont des shells non interactifs (OK)." 1
    else
        Azeez_AjouterLigne "[SYS-ACCOUNTS][CIS-5.4.2.7-SYS-SHELL] au moins un compte système avec shell interactif (NON conforme)." 0
    fi
}

# 5.4.3.2 – TMOUT=900 dans /etc/profile
Azeez_Test_TMOUT() {
    local attendu=900
    local courant
    courant=$(grep -E "^[[:space:]]*TMOUT=" /etc/profile 2>/dev/null | tail -n1 | cut -d'=' -f2)

    if [ "$courant" = "$attendu" ]; then
        Azeez_AjouterLigne "[TMOUT][CIS-5.4.3.2-TMOUT] TMOUT=$courant (OK, attendu=$attendu)." 1
    else
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[TMOUT][CIS-5.4.3.2-TMOUT] TMOUT=$courant (NON conforme, mise à $attendu par Azeez)." 0
            if grep -qE "^[[:space:]]*TMOUT=" /etc/profile 2>/dev/null; then
                sed -i "s/^[[:space:]]*TMOUT=.*/TMOUT=$attendu/" /etc/profile 2>/dev/null
            else
                echo "TMOUT=$attendu" >> /etc/profile
            fi
        else
            [ -z "$courant" ] && courant="non défini"
            Azeez_AjouterLigne "[TMOUT][CIS-5.4.3.2-TMOUT] TMOUT=$courant (NON conforme, attendu=$attendu)." 0
        fi
    fi
}

# 6.1.1.1 – journald actif
Azeez_Test_Journald() {
    local enabled active
    enabled=$(systemctl is-enabled systemd-journald 2>/dev/null || echo "unknown")
    active=$(systemctl is-active systemd-journald 2>/dev/null || echo "unknown")

    if [ "$active" = "active" ]; then
        Azeez_AjouterLigne "[JOURNALD][CIS-6.1.1.1-JOURNALD] systemd-journald est actif." 1
    else
        if Azeez_PeutCorriger; then
            Azeez_AjouterLigne "[JOURNALD][CIS-6.1.1.1-JOURNALD] systemd-journald (enabled=$enabled, active=$active) -> tentative start/enable par Azeez." 0
            systemctl start systemd-journald 2>/dev/null
            systemctl enable systemd-journald 2>/dev/null
        else
            Azeez_AjouterLigne "[JOURNALD][CIS-6.1.1.1-JOURNALD] systemd-journald pas actif (enabled=$enabled, active=$active)." 0
        fi
    fi
}

# 6.1.1.4 – un seul système de log (rsyslog / syslog-ng)
Azeez_Test_LoggingSystem() {
    local r s
    dpkg -s rsyslog >/dev/null 2>&1
    r=$?
    dpkg -s syslog-ng >/dev/null 2>&1
    s=$?

    local count=0
    [ $r -eq 0 ] && count=$((count+1))
    [ $s -eq 0 ] && count=$((count+1))

    if [ "$count" -le 1 ]; then
        Azeez_AjouterLigne "[LOGGING][CIS-6.1.1.4-LOGGING] au plus un système de logs (rsyslog=$([ $r -eq 0 ] && echo 1 || echo 0), syslog-ng=$([ $s -eq 0 ] && echo 1 || echo 0))." 1
    else
        Azeez_AjouterLigne "[LOGGING][CIS-6.1.1.4-LOGGING] plusieurs systèmes de logs (rsyslog=$([ $r -eq 0 ] && echo 1 || echo 0), syslog-ng=$([ $s -eq 0 ] && echo 1 || echo 0))." 0
    fi
}

# 7.1.1 – /etc/passwd permission 644 root:root
Azeez_Test_PasswdPerms() {
    local mode owner group
    mode=$(stat -c "%a" /etc/passwd 2>/dev/null)
    owner=$(stat -c "%U" /etc/passwd 2>/dev/null)
    group=$(stat -c "%G" /etc/passwd 2>/dev/null)

    if [ "$mode" = "644" ] && [ "$owner" = "root" ] && [ "$group" = "root" ]; then
        Azeez_AjouterLigne "[FILE][CIS-7.1.1-PASSWD] /etc/passwd : mode=$mode, owner=$owner, group=$group (OK)." 1
    else
        local texte="[FILE][CIS-7.1.1-PASSWD] /etc/passwd : mode=$mode, owner=$owner, group=$group (NON conforme, attendu 644 root:root)."
        if Azeez_PeutCorriger; then
            chmod 644 /etc/passwd 2>/dev/null
            chown root:root /etc/passwd 2>/dev/null
            texte="$texte Correction appliquée par Azeez."
        fi
        Azeez_AjouterLigne "$texte" 0
    fi
}

#######################################################################################
#  MAIN : appel des tests dans l'ordre demandé
#######################################################################################


Azeez_AjouterLigne "=== Azeez - début traitement fichier $Azeez_FichierXML ===" 0

# paquetages
Azeez_Test_Telnet
Azeez_Test_Ftp
Azeez_Test_UfwInstalle

# réseau / firewall
Azeez_Test_IpForward
Azeez_Test_UnSeulFirewall
Azeez_Test_UfwEnabled

# mots de passe / comptes
Azeez_Test_PassMaxDays
Azeez_Test_PassWarnAge
Azeez_Test_PasswordHash
Azeez_Test_UseraddInactive
Azeez_Test_LastChange
Azeez_Test_UID0
Azeez_Test_GID0
Azeez_Test_RootSSH
Azeez_Test_SystemAccountsShell
Azeez_Test_TMOUT

# journaux / fichiers
Azeez_Test_Journald
Azeez_Test_LoggingSystem
Azeez_Test_PasswdPerms

Azeez_AjouterLigne "=== Azeez - fin du traitement ===" 0

#  écriture éventuelle dans un fichier 
if [ -n "$Azeez_FichierSortie" ]; then
    {
        for ligne in "${Azeez_Lines[@]}"; do
            echo "$ligne"
        done
    } > "$Azeez_FichierSortie"
fi

exit 0