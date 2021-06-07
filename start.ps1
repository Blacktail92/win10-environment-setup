<# notes
iso icinde her turden sadece bir adet dosya olmalı
registry entry leri gibi sik degismeyen dosyaları gist yapabilirim
bi baska script .reg vb dosyalarin backuplarini alir onlari git e yukler
temp e work dir olustur, gerekli hersey oraya insin, oradan kurulum yap, kurulum bitince klasoru sil
#>

# elevate the script
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

function Save-GitHubRepository
{
    param(
        [Parameter(Mandatory)]
        [string]$Owner,

        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter(Mandatory)]
        [string]$Location,

        [Parameter()]
        [string]$Branch = 'master'
    )

    $url = "https://github.com/$Owner/$Project/archive/$Branch.zip"
    $file = Join-Path $Location "${Project}-${Branch}.zip"

    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $file)

    Expand-Archive $file -Force
    Remove-Item $file -Force
}

# change execution policy
Write-Output "Change execution policy"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force # boxstarter.common.psm1 cannot be loaded because running scripts is disabled on this system.
Get-ExecutionPolicy

# stop services that may interrupt the process
$services = @(
    "wuauserv"
)
Write-Output "Stopping services that may interrupt the process"
$services | ForEach-Object {Write-Output "Stopping $_"; Stop-Service $_ -Force -NoWait}

# services
Set-Service -Name volmgrx -StartupType Automatic -Status Running

# ask user for old appdata folder
# $appdata_folder =

# $work_dir = Join-Path -Path $env:temp -ChildPath win10_env_setup
# Remove-Item $env:temp/win10_env_setup
# mkdir $work_dir

# activate windows with digital license
Write-Output "Download GitHub repo: massgravel/Microsoft-Activation-Scripts"
Save-GitHubRepository -Owner "massgravel" -Project "Microsoft-Activation-Scripts" -Location $PSScriptRoot

Write-Output "Activate Windows with digital license"
Start-Process -FilePath "Microsoft-Activation-Scripts-master\Microsoft-Activation-Scripts-master\MAS_1.4\Separate-Files-Version\Activators\HWID-KMS38_Activation\HWID_Activation.cmd" -ArgumentList "/u" -Wait
Write-Output "Check activation status"
slmgr /xpr

# disable hpet
Write-Output "Disable HPET"
bcdedit /set useplatformclock no
bcdedit /set disabledynamictick yes

# power plan
# powercfg -devicequery wake_armed # List devices that are currently configured to wake the system from any sleep state.
Write-Output "Unhide Ultimate Performance power plan"
powercfg -duplicatescheme "e9a42b02-d5df-448d-aa00-03f14749eb61"

Write-Output "Change power plan to ggOS"
$guid_ggOS = [guid]::NewGuid()
powercfg /import "$PSScriptRoot/ggOS.pow" $guid_ggOS
powercfg /setactive $guid_ggOS

# modify power plan
powercfg /hibernate off
powercfg /change monitor-timeout-ac 10
powercfg /change monitor-timeout-dc 10

# allow devices to wake the system
Write-Output "Allow user-configurable devices to wake the system"
powercfg -devicequery wake_programmable | ForEach-Object {powercfg -deviceenablewake $_} # Lists devices that are user-configurable to wake the system from a sleep state.

Write-Output "List of devices allowed to wake the system:"
powercfg -devicequery wake_armed

#todo Change Split Threshold for svchost.exe in Windows 10

# change ntp server
Start-Service w32time
Start-Process w32tm -ArgumentList "/config /update /manualpeerlist:time.cloudflare.com /syncfromflags:MANUAL"
w32tm /query /status
W32tm /resync /force

# change language
# todo: add en-gb language pack
Write-Output "Set language and locale to en-GB"
$language = "en-GB"
Set-Culture $language
Set-WinSystemLocale -SystemLocale $language
Set-WinUILanguageOverride -Language $language
Set-WinUserLanguageList $language, "tr-TR" -Force
Set-WinHomeLocation -GeoId 242 # uk:242, us:244, tr:235
Set-TimeZone "Turkey Standard Time" # utc+3

# change short date format to ISO 8601
Write-Output "Change date format to ISO 8601"
$isoDate = Get-Culture
$isoDate.DateTimeFormat.ShortDatePattern = "yyyy-MM-dd"
Set-Culture $isoDate

# optional windows features
# Get-WindowsOptionalFeature -Online # Lists optional features in the running operating system
Write-Output "Configure Windows optional features"
$enable_features = @(
)

$disable_features = @(
    "Containers-DisposableClientVM" # Windows Sandbox. Sandboxie is better.
    "WorkFolders-Client"
    "Internet-Explorer-Optional-amd64" # Not used.
    "Microsoft-Hyper-V" # Cant install foxOS, ggOS so no point in installing.
)

$enable_features | ForEach-Object {Enable-WindowsOptionalFeature –FeatureName $_ -All -Online -NoRestart}

$disable_features | ForEach-Object {
    Write-Output "Disabling $_"
    Disable-WindowsOptionalFeature –FeatureName $_ -Online -NoRestart
}

# install nuget
Write-Output "Install NuGet"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force # PowerShellGet requires NuGet provider version '2.8.5.201' or newer to interact with NuGet-based repositories.
Register-PackageSource -Name NuGet -Location https://www.nuget.org/api/v2 -ProviderName NuGet -Trusted # needed to install Microsoft.UI.Xaml
Install-Package Microsoft.UI.Xaml # needed for some choco packages (modernflyouts)

# install and configure chocolatey
Write-Output "Install Chocolatey"
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable --name allowGlobalConfirmation

# scripts
Write-Output "Execute additional scripts"
."$PSScriptRoot\chocolatey.ps1"
."$PSScriptRoot\registry.ps1"

# default service'ler haricindeki butun service'leri demand start moduna alabilirim ve bunu bi scheduled task haline getirebilirim. boylece hicbir service gereksiz calismaz.

# todo: set MSI mode for supperted devices

# todo: export all console content to a .log file at the end.

# todo: reboot

pause
