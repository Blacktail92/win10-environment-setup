@echo off
echo Creating scheduled task to continue installation at first logon...

:: Raw URL of the powershell script to be executed
set _URL=https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10Debloater.ps1

:: Task name and arguments
set _TaskName=env_setup
set _TaskArgs=Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('%_URL%')); Unregister-ScheduledTask -TaskName %_TaskName% -Confirm:`$false

:: Task settings
set _Principal=$P = New-ScheduledTaskPrincipal -GroupId Administrators -RunLevel Highest
set _Trigger=$T = New-ScheduledTaskTrigger -AtLogon
set _Settings=$S = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
set _Action=$A = New-ScheduledTaskAction -Execute powershell -Argument \"%_TaskArgs%\"
set _CreateTask=$C = New-ScheduledTask -Principal $P -Trigger $T -Settings $S -Action $A
set _RegTask=Register-ScheduledTask -TaskName %_TaskName% -Force -InputObject $C
set _PSCmds=%_Principal%; %_Trigger%; %_Settings%; %_Action%; %_CreateTask%; %_RegTask%

:: Register configured scheduled task
powershell -command %_PSCmds%

echo Task created.
