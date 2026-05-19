#######################################################################################
# AzeezScriptWin.ps1
# Nom : Abdul-Bariu Ishola Azeez
# But : Script de sécurisation Windows 11 basé sur un fichier XML.
#       Script lit un fichier XML avec des règles de sécurité
# Récepteur : M. Gilles Lacasse
#######################################################################################



# Initaialisation de variiables

$XmlFile       = $null 
$ModeValidate  = $false
$ModeCorrect   = $false
$ModeQuiet     = $false
$OutFilePath   = $null
$ScreenAndFile = $false

# Cette boucle lit chaque argument ($args) passé au script.
# Avec "switch", on regarde si c’est -f, -v, -c, -q, -s ou -2
# et on règle la bonne variable selon l’option trouvée.
# Si l’option demande un fichier après (comme -f ou -s),
# on vérifie qu’il y a bien un argument en plus, sinon on affiche une erreur.

for ($i = 0; $i -lt $args.Count; $i++) {
    switch ($args[$i]) {
        '-f' {
            if ($i + 1 -ge $args.Count) {
                Write-Host "Erreur : il manque le nom du fichier après -f."
                exit 1
            }
            $XmlFile = $args[$i + 1]
            $i++
        }
        '-v' { $ModeValidate = $true }
        '-c' { $ModeCorrect  = $true }
        '-q' { $ModeQuiet    = $true }
        '-s' {
            if ($i + 1 -ge $args.Count) {
                Write-Host "Erreur : il manque le nom du fichier après -s."
                exit 1
            }
            $OutFilePath = $args[$i + 1]
            $i++
        }
        '-2' { $ScreenAndFile = $true }
        default {
            Write-Host "Attention : option inconnue $($args[$i]) (ignorée)."
        }
    }
}

# Ici on vérifie que les paramètres obligatoires sont bien présents
# et qu’ils ont du sens. Si quelque chose manque ou est incohérent,
# on affiche un message d’erreur clair et on arrête le script.

if (-not $XmlFile) {
    Write-Host "Erreur : l'option -f <fichier.xml> est obligatoire."
    exit 1
}

if (-not (Test-Path -LiteralPath $XmlFile)) {
    Write-Host "Erreur : fichier XML '$XmlFile' introuvable."
    exit 1
}

if ($ScreenAndFile -and -not $OutFilePath) {
    Write-Host "Erreur : -2 doit être utilisé en même temps que -s <fichier_sortie>."
    exit 1
}

if (-not $ModeValidate -and -not $ModeCorrect) {
    # Si ni -v ni -c : on suppose validation seule
    $ModeValidate = $true
}

#  2. Gestion de la sortie (écran / fichier / -q) 
# Dans cette partie, on décide où vont les messages :
# seulement à l’écran, seulement dans un fichier, ou les deux.
# On gère aussi le mode silencieux (-q) qui cache les messages “OK”.

$Global:ResultLines = @()

# La fonction Add-CheckLine sert à afficher les résultats des vérifications :
# chaque ligne dit si une règle est respectée ou non.
# Elle enregistre aussi tout dans un tableau ($ResultLines)
# pour qu’on puisse l’écrire dans un fichier à la fin.

function Add-CheckLine {
    param(
        [string]$Text,
        [bool]$IsOk
    )

    $Global:ResultLines += $Text

    $showOnScreen = $true

    if ($OutFilePath -and -not $ScreenAndFile) {
        # Mode "-s" seul : on garde tout pour le fichier, pas d'affichage écran
        $showOnScreen = $false
    }
    elseif ($ModeQuiet) {
        # Mode "-q" : on montre seulement les lignes NON conformes
        if ($IsOk) {
            $showOnScreen = $false
        }
    }

    if ($showOnScreen) {
        Write-Host $Text
    }
}

# La fonction Add-InfoLine est pour les messages d’information simples
# (par exemple : début ou fin du script).
# Elle respecte aussi le choix écran/fichier comme Add-CheckLine.

function Add-InfoLine {
    param(
        [string]$Text
    )

    $Global:ResultLines += $Text

    $showOnScreen = $true
    if ($OutFilePath -and -not $ScreenAndFile) {
        $showOnScreen = $false
    }

    if ($showOnScreen) {
        Write-Host $Text
    }
}

#  3. Lecture du fichier XML 
# Ici on essaie de charger le contenu du fichier XML donné par -f.
# Si la lecture échoue (mauvais chemin, fichier corrompu, etc.),
# on affiche une erreur et on arrête tout, car le script dépend du XML.

try {
    [xml]$xmlContent = Get-Content -LiteralPath $XmlFile -ErrorAction Stop
}
catch {
    Write-Host "Erreur : impossible de lire le XML : $_"
    exit 1
}

# On récupère toutes les balises <rule> du fichier XML.
# Chaque <rule> représente une règle de sécurité à vérifier ou corriger.

$rules = $xmlContent.config.rule
if (-not $rules) {
    Write-Host "Erreur : aucune balise <rule> trouvée dans le XML."
    exit 1
}

Add-InfoLine "=== Azeez - début du traitement pour '$XmlFile' ==="

#  4. Fonctions utilitaires pour chaque type 
# Dans cette grosse section, il y a plusieurs fonctions.
# Chaque fonction gère un type de règle différent :
# mot de passe, verrouillage, compte, service, firewall et audit.
# Ça rend le code plus organisé et plus facile à comprendre.

# NOTE IMPORTANTE : ici on ne typpe plus le paramètre $Rule avec [xml],
# sinon PowerShell essaie de convertir XmlElement en XmlDocument et ça plante.

# Cette fonction s’occupe des règles de type "password".
# Elle lit les paramètres de mot de passe (longueur, complexité, etc.)
# et compare avec les valeurs attendues dans le XML.
# Si le mode correction est activé, elle change les réglages.

function TestAndFix-PasswordRule {
    param(
        $Rule
    )

    $id       = $Rule.id
    $field    = $Rule.field
    $expected = [string]$Rule.expected

    # On utilise la commande "net accounts" pour lire les infos de mot de passe
    $netLines = net accounts

    switch ($field) {
        'EnforceHistory' {
            $line = $netLines | Where-Object { $_ -match 'History' -or $_ -match 'historique' }
            $isOk = $false
            if ($line -match '(\d+)') {
                $val = [int]$Matches[1]
                if ($val -ge [int]$expected) { $isOk = $true }
            }
            Add-CheckLine "[$id] Historique mots de passe : ligne='$line' / attendu >= $expected" $isOk
            if (-not $isOk -and $ModeCorrect) {
                net accounts /UNIQUEPW:$expected | Out-Null
                Add-CheckLine "[$id] Historique ajusté par Azeez à $expected mots de passe." $false
            }
        }
        'MaxAge' {
            $line = $netLines | Where-Object { $_ -match 'Maximum password age' -or $_ -match 'Durée maximale du mot de passe' }
            $isOk = $false
            if ($line -match '(\d+)') {
                $val = [int]$Matches[1]
                if ($val -le [int]$expected -and $val -gt 0) { $isOk = $true }
            }
            Add-CheckLine "[$id] Durée max mot de passe : ligne='$line' / attendu <= $expected et > 0" $isOk
            if (-not $isOk -and $ModeCorrect) {
                net accounts /MAXPWAGE:$expected | Out-Null
                Add-CheckLine "[$id] Durée max ajustée par Azeez à $expected jour(s)." $false
            }
        }
        'MinAge' {
            $line = $netLines | Where-Object { $_ -match 'Minimum password age' -or $_ -match 'Durée minimale du mot de passe' }
            $isOk = $false
            if ($line -match '(\d+)') {
                $val = [int]$Matches[1]
                if ($val -ge [int]$expected) { $isOk = $true }
            }
            Add-CheckLine "[$id] Durée min mot de passe : ligne='$line' / attendu >= $expected" $isOk
            if (-not $isOk -and $ModeCorrect) {
                net accounts /MINPWAGE:$expected | Out-Null
                Add-CheckLine "[$id] Durée min ajustée par Azeez à $expected jour(s)." $false
            }
        }
        'MinLength' {
            $line = $netLines | Where-Object { $_ -match 'Minimum password length' -or $_ -match 'Longueur minimale du mot de passe' }
            $isOk = $false
            if ($line -match '(\d+)') {
                $val = [int]$Matches[1]
                if ($val -ge [int]$expected) { $isOk = $true }
            }
            Add-CheckLine "[$id] Longueur min mot de passe : ligne='$line' / attendu >= $expected" $isOk
            if (-not $isOk -and $ModeCorrect) {
                net accounts /MINPWLEN:$expected | Out-Null
                Add-CheckLine "[$id] Longueur min ajustée par Azeez à $expected caractères." $false
            }
        }
        'Complexity' {
            $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
            $name    = 'PasswordComplexity'
            $current = (Get-ItemProperty -Path $regPath -Name $name -ErrorAction SilentlyContinue).$name
            $expectedBit = if ($expected -eq 'Enabled') { 1 } else { 0 }
            $isOk = ($current -eq $expectedBit)
            Add-CheckLine "[$id] Complexité mots de passe : actuel=$current / attendu=$expectedBit" $isOk
            if (-not $isOk -and $ModeCorrect) {
                Set-ItemProperty -Path $regPath -Name $name -Value $expectedBit -Type DWord
                Add-CheckLine "[$id] Complexité mise à jour par Azeez (valeur=$expectedBit)." $false
            }
        }
        'RelaxMinLength' {
            Add-CheckLine "[$id] Relax minimum password length : info seulement, souvent géré par GPO (aucune action script)." $true
        }
        'ReversibleEncryption' {
            $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
            $name    = 'ClearTextPassword'
            $current = (Get-ItemProperty -Path $regPath -Name $name -ErrorAction SilentlyContinue).$name
            $expectedBit = if ($expected -eq 'Disabled') { 0 } else { 1 }
            $isOk = ($current -eq $expectedBit)
            Add-CheckLine "[$id] Stockage réversible : actuel=$current / attendu=$expectedBit" $isOk
            if (-not $isOk -and $ModeCorrect) {
                Set-ItemProperty -Path $regPath -Name $name -Value $expectedBit -Type DWord
                Add-CheckLine "[$id] Stockage réversible ajusté par Azeez (valeur=$expectedBit)." $false
            }
        }
        default {
            Add-CheckLine "[$id] Sous-type mot de passe inconnu : '$field' (ignoré)." $false
        }
    }
}

# Cette fonction gère les règles de verrouillage de compte (lockout).
# Elle regarde au bout de combien de tentatives ratées le compte se bloque,
# combien de temps il reste verrouillé, etc.
# En mode correction, elle ajuste ces paramètres avec "net accounts".

function TestAndFix-LockoutRule {
    param(
        $Rule
    )

    $id       = $Rule.id
    $field    = $Rule.field
    $expected = [int]$Rule.expected

    $netLines = net accounts

    switch ($field) {
        'Duration' {
            $line = $netLines | Where-Object { $_ -match 'Lockout duration' -or $_ -match 'Durée de verrouillage' }
            $isOk = $false
            if ($line -match '(\d+)') {
                $val = [int]$Matches[1]
                if ($val -ge $expected) { $isOk = $true }
            }
            Add-CheckLine "[$id] Durée verrouillage : ligne='$line' / attendu >= $expected" $isOk
            if (-not $isOk -and $ModeCorrect) {
                net accounts /LOCKOUTDURATION:$expected | Out-Null
                Add-CheckLine "[$id] Durée verrouillage ajustée par Azeez à $expected minute(s)." $false
            }
        }
        'Threshold' {
            $line = $netLines | Where-Object { $_ -match 'Lockout threshold' -or $_ -match 'Déclenchement du verrouillage' }
            $isOk = $false
            if ($line -match '(\d+)') {
                $val = [int]$Matches[1]
                if ($val -le $expected -and $val -gt 0) { $isOk = $true }
            }
            Add-CheckLine "[$id] Seuil verrouillage : ligne='$line' / attendu <= $expected et > 0" $isOk
            if (-not $isOk -and $ModeCorrect) {
                net accounts /LOCKOUTTHRESHOLD:$expected | Out-Null
                Add-CheckLine "[$id] Seuil verrouillage ajusté par Azeez à $expected tentative(s)." $false
            }
        }
        'ResetCounter' {
            $line = $netLines | Where-Object { $_ -match 'Lockout observation window' }
            $isOk = $false
            if ($line -match '(\d+)') {
                $val = [int]$Matches[1]
                if ($val -ge $expected) { $isOk = $true }
            }
            Add-CheckLine "[$id] Reset compteur verrouillage : ligne='$line' / attendu >= $expected" $isOk
            if (-not $isOk -and $ModeCorrect) {
                net accounts /LOCKOUTWINDOW:$expected | Out-Null
                Add-CheckLine "[$id] Fenêtre verrouillage ajustée par Azeez à $expected minute(s)." $false
            }
        }
        default {
            Add-CheckLine "[$id] Sous-type lockout inconnu : '$field' (ignoré)." $false
        }
    }
}

# Cette fonction s’occupe des règles sur les comptes utilisateurs.
# Par exemple, elle peut vérifier si le compte invité (Guest) est désactivé
# ou si les mots de passe vides sont interdits.

function TestAndFix-AccountRule {
    param(
        $Rule
    )

    $id       = $Rule.id
    $field    = $Rule.field
    $expected = [string]$Rule.expected

    switch ($field) {
        'GuestStatus' {
            $guest = Get-LocalUser -Name 'Guest' -ErrorAction SilentlyContinue
            if (-not $guest) {
                Add-CheckLine "[$id] Compte 'Guest' introuvable sur ce système." $true
                return
            }
            $isDisabled = -not $guest.Enabled
            $isOk = $isDisabled
            Add-CheckLine "[$id] Statut Guest : Enabled=$($guest.Enabled) / attendu=Disabled." $isOk
            if (-not $isOk -and $ModeCorrect) {
                Disable-LocalUser -Name 'Guest'
                Add-CheckLine "[$id] Compte Guest désactivé par Azeez." $false
            }
        }
        'LimitBlankPasswordUse' {
            $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
            $name    = 'LimitBlankPasswordUse'
            $current = (Get-ItemProperty -Path $regPath -Name $name -ErrorAction SilentlyContinue).$name
            $expectedBit = if ($expected -eq 'Enabled') { 1 } else { 0 }
            $isOk = ($current -eq $expectedBit)
            Add-CheckLine "[$id] Limiter mots de passe vides : actuel=$current / attendu=$expectedBit" $isOk
            if (-not $isOk -and $ModeCorrect) {
                Set-ItemProperty -Path $regPath -Name $name -Value $expectedBit -Type DWord
                Add-CheckLine "[$id] LimitBlankPasswordUse ajusté par Azeez (valeur=$expectedBit)." $false
            }
        }
        default {
            Add-CheckLine "[$id] Sous-type account inconnu : '$field' (ignoré)." $false
        }
    }
}

# Cette fonction gère les services Windows (comme FTP, etc.).
# Elle vérifie si un service doit être désactivé.
# Si le service n’existe pas, on considère que c’est bon.
# Sinon, on vérifie son type de démarrage et on le désactive si nécessaire.

function TestAndFix-ServiceRule {
    param(
        $Rule
    )

    $id       = $Rule.id
    $field    = $Rule.field   # ex: FTPSVC
    $expected = [string]$Rule.expected

    $svc = Get-Service -Name $field -ErrorAction SilentlyContinue
    if (-not $svc) {
        Add-CheckLine "[$id] Service '$field' non installé (OK pour la règle)." $true
        return
    }

    $isDisabled = ($svc.StartType -eq 'Disabled')
    $isOk = $isDisabled
    Add-CheckLine "[$id] Service $field : StartType=$($svc.StartType) / attendu=Disabled ou non installé." $isOk

    if (-not $isOk -and $ModeCorrect) {
        try {
            Stop-Service -Name $field -Force -ErrorAction SilentlyContinue
        } catch {}
        Set-Service -Name $field -StartupType Disabled
        Add-CheckLine "[$id] Service $field désactivé par Azeez." $false
    }
}

# Cette fonction s’occupe des règles liées au pare-feu (firewall).
# Elle vérifie si le profil (Domaine, Privé, Public) est activé ou non.
# En mode correction, elle active le firewall si ce n’est pas conforme.

function TestAndFix-FirewallRule {
    param(
        $Rule
    )

    $id       = $Rule.id
    $field    = $Rule.field      # Domain / Private / Public
    $expected = [string]$Rule.expected

    $profile = Get-NetFirewallProfile -Name $field -ErrorAction SilentlyContinue
    if (-not $profile) {
        Add-CheckLine "[$id] Profil firewall '$field' introuvable." $false
        return
    }

    $isOn = ($profile.Enabled -eq 'True' -or $profile.Enabled -eq 1)
    $expectedOn = ($expected -like 'On*')
    $isOk = ($isOn -eq $expectedOn)

    $etatTexte = if ($isOn) { 'On' } else { 'Off' }
    Add-CheckLine "[$id] Firewall $field : état actuel=$etatTexte / attendu=On." $isOk

    if (-not $isOk -and $ModeCorrect) {
        Set-NetFirewallProfile -Name $field -Enabled True
        Add-CheckLine "[$id] Firewall $field activé par Azeez." $false
    }
}

# Cette fonction gère les règles d’audit (auditpol).
# Elle regarde ce qui est enregistré dans les journaux de sécurité,
# par exemple : succès et/ou échecs d’authentification.
# En mode correction, elle modifie la configuration d’audit.

function TestAndFix-AuditRule {
    param(
        $Rule
    )

    $id       = $Rule.id
    $field    = [string]$Rule.field   # ex: "Credential Validation"
    $expected = [string]$Rule.expected

    $currentText = (auditpol /get /subcategory:"$field" 2>$null) -join ' '
    $isOk = $false
    if ($expected -eq 'SuccessAndFailure') {
        if ($currentText -match 'Success' -and $currentText -match 'Failure') { $isOk = $true }
    }
    elseif ($expected -eq 'Failure') {
        if ($currentText -match 'Failure') { $isOk = $true }
    }

    Add-CheckLine "[$id] Audit '$field' : actuel='$currentText' / attendu=$expected" $isOk

    if (-not $isOk -and $ModeCorrect) {
        if ($expected -eq 'SuccessAndFailure') {
            auditpol /set /subcategory:"$field" /success:enable /failure:enable | Out-Null
        }
        elseif ($expected -eq 'Failure') {
            auditpol /set /subcategory:"$field" /success:disable /failure:enable | Out-Null
        }
        Add-CheckLine "[$id] Audit '$field' ajusté par Azeez vers '$expected'." $false
    }
}

#  5. Boucle principale sur les règles 
# Maintenant qu’on a toutes les fonctions prêtes,
# on parcourt chaque règle du XML ($rules) une par une.
# Selon la catégorie (password, lockout, account, etc.),
# on appelle la bonne fonction de test/correction.

foreach ($rule in $rules) {
    $cat = [string]$rule.category

    switch ($cat) {
        'password' { TestAndFix-PasswordRule -Rule $rule }
        'lockout'  { TestAndFix-LockoutRule  -Rule $rule }
        'account'  { TestAndFix-AccountRule  -Rule $rule }
        'service'  { TestAndFix-ServiceRule  -Rule $rule }
        'firewall' { TestAndFix-FirewallRule -Rule $rule }
        'audit'    { TestAndFix-AuditRule    -Rule $rule }
        default {
            Add-CheckLine "[INCONNU] Catégorie inconnue '$cat' dans le XML, règle ignorée." $false
        }
    }
}

Add-InfoLine "=== Azeez - fin du traitement ==="

#  6. Écriture éventuelle du fichier de sortie 
# À la fin, si l’utilisateur a donné l’option -s,
# on enregistre toutes les lignes de résultats ($ResultLines)
# dans un fichier texte (UTF-8).
# Comme ça, il reste une trace complète du rapport.

if ($OutFilePath) {
    try {
        $Global:ResultLines | Set-Content -Path $OutFilePath -Encoding UTF8
    }
    catch {
        Write-Host "Erreur : impossible d'écrire dans le fichier '$OutFilePath' : $_"
        exit 1
    }
}