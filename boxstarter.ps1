# iso icinde her turden sadece bir adet dosya olmalı
# registry entry leri gibi sik degismeyen dosyaları gist yapabilirim
# bi baska script .reg vb dosyalarin backuplarini alir onlari git e yukler
# temp e work dir olustur, gerekli hersey oraya insin, oradan kurulum yap, kurulum bitince klasoru sil

# Elevate the script.
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

# Prepare Windows environment for unattended installations.
Set-ExecutionPolicy Bypass -Scope Process -Force # boxstarter.common.psm1 cannot be loaded because running scripts is disabled on this system.
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force # PowerShellGet requires NuGet provider version '2.8.5.201' or newer to interact with NuGet-based repositories.
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted # Add PSGallery to trusted repositories. Requires NuGet.

# Install and configure Chocolatey for unattended installations.
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable --name allowGlobalConfirmation

# Choco packages.
$choco_pkgs = @(
    "boxstarter"
    "brave-nightly --pre"
)

# Boxstarter-choco packages.
$box_choco_pkgs = @(
    'dotnet3.5'
    'dotnetfx'
    "firacode"
    "sysinternals"
    '7zip'
    'peazip'
    'notepadplusplus'
    'bulk-crap-uninstaller'
    'toolwiz-time-freeze'
    'filezilla.server'
    'everything'
    'vscode'
    'git'
    'github-desktop'
    'virtualbox'
    'virtualmachineconverter'
    'winscp'
    'wincdemu'
    'sharex'
    # 'ntlite-free' # error: checksums do not match.
)

# Boxstarter packages.
$box_pkgs = @(

)

# processhacker 3
# msi afterburner beta
# Install-BoxstarterPackage brave-nightly --pre # returns error
# Install-BoxstarterPackage xyplorer # Error - hashes do not match.

# Install features and capabilities.
$capabilities = @(
    "wordpad"
    "xps"
    "msix"
    "netfx3"
    "mediafeaturepack"
)

($capabilities).ForEach( {
        Clear-Host; Write-Host "Installing $_..." -BackgroundColor Black -ForegroundColor Green
        Get-WindowsCapability -Online -Name *$_* | Add-WindowsCapability -Online
    })

Update-Help -force

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
