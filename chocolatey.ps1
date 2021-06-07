# Choco packages
$choco_packages = @(
    "jetbrainsmono"
    "brave"
    "open-shell"
    "teracopy"
    "7zip"
    "vscode" # associate all suppported file extensions
    # "powershell" last updated: 11 Aug 2018. latest version: 5.1.14409.20180811
    "sdio" # snappy driver installer origin
    "devmanview"
    "fluent-terminal"
    "dismplusplus"
    "rapr" # Driver Store Explorer [RAPR] (open source)
    "regeditor" # O&O RegEdit
    "regfromapp"
    "powershell-core"
    "winaero-tweaker"
    "chocolateygui"
    "voicemeeter-potato"
    "notepadplusplus"
    "sysinternals"
    "nvidia-profile-inspector"
    "steam-client"
    "bitwarden"
    "bitwarden-cli"
    "keepassxc"
    "xyplorer"
    "soundswitch"
    # "kis" # Kaspersky Internet Security
    # "dotnet3.5"
    # "dotnet4.5.2"
    # "dotnetfx" # DEPRECATED
    # "vcredist140" # Microsoft Visual C++ Redistributable for Visual Studio 2015-2019
    # "jre8" # Java SE Runtime Environment
    "brave-nightly"
    "bulk-crap-uninstaller"
    "toolwiz-time-freeze"
    "filezilla.server"
    "everything"
    "powertoys"
    "git"
    "python3"
    # "microsoft-windows-terminal"
    "github-desktop"
    # "virtualbox"
    "virtualmachineconverter"
    "winscp"
    "wincdemu"
    "sharex"
    "k-litecodecpack-standard"
    "shutup10"
    "syncthing"
    "discord"
    "msiafterburner"
    "tor-browser"
    "hwinfo"
    "scrcpy"
    "universal-adb-drivers"
    "telegram"
    "zerotier-one"
    "signal"
    "stremio"
    "dropbox"
    "audacity"
    "subtitleedit"
    "origin"
    "teamspeak"
    "anydesk"
    "ventoy"
    "ddu"
    "handbrake" # open source video transcoder
    "notion"
    "steam-cleaner"
    "latencymon"
    "modernflyouts"
    "lunacy"
    "foobar2000"
    "imageglass"
    "thunderbird"
    "qbittorrent"
    "obs-studio"
    "libreoffice-fresh"
    "onlyoffice"
    "bluescreenview"
    "ueli" # a keystroke launcher for Windows and macOS
    "crystaldiskmark"
    # "networkmanager"
    # "ntlite-free" # error: checksums do not match.
)

# capframex
# processhacker 3

$choco_packages | ForEach-Object {choco install $_}

# .appinstaller uzantisini yuklemek icin magazadan App Installer yuklemek ve "enable sideload apps mode" gerekiyor

# syncthing service
New-Service Syncthing $env:ChocolateyInstall/bin/syncthing.exe -StartupType Automatic
Start-Service Syncthing







# Install features and capabilities
#$capabilities = @(
#    "xps"
#    "msix"
#    "netfx3"
#    "mediafeaturepack"
#)

#($capabilities).ForEach( {
#        Write-Host "Installing $_..." -BackgroundColor Black -ForegroundColor Green
#        Get-WindowsCapability -Online -Name *$_* | Add-WindowsCapability -Online
#    })

# Update-Help -Force

# Get-WindowsCapability outputs "Microsoft.Dism.Commands.AdvancedCapabilityObject" if true



# Get-WindowsCapability -online -Name *"rsat"* | where Name VolumeActivation

# Enable-WindowsOptionalFeature -Online -FeatureName *"Hyper"* -All
# Enable-WindowsOptionalFeature outputs "Microsoft.Dism.Commands.ImageObject"  if true
# -FeatureName ve -PackageName wildcard kabul etmiyo
# Get-WindowsOptionalFeature -Online -FeatureName *"Hyper"* | Where-Object -Property State -EQ "Disabled"

# Install custom scripts.
# Write-BoxstarterMessage "Installing custom scripts..." -nologo -color cyan

# Install-BoxstarterPackage -PackageName "E://Programs//sharpapp//scripts//Apps//Open privacy settings.ps1" -Force

# Invoke-BoxStarter [[-ScriptToCall] <ScriptBlock>] [[-password] <SecureString>] [[-RebootOk]] [[-encryptedPassword] <String>] [[-KeepWindowOpen]] [[-NoPassword]] [[-DisableRestart]] [<CommonParameters>]

# Update PowerShell help module
# Update-Help

# faceit ac link
# https://onedrive.live.com/download?cid=1E510E730A5080D3&resid=1E510E730A5080D3%211039&authkey=AKvpG2CQY_I8VCE

pause