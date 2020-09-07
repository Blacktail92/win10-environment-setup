@echo off
echo Creating scheduled task to continue installation at first logon...

:: Raw URL of the powershell script to be executed
SET _URL=https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10Debloater.ps1

:: Task name and arguments
SET _TaskName=env_setup
SET _TaskArgs=Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('%_URL%')); Unregister-ScheduledTask -TaskName %_TaskName% -Confirm:`$false

:: Task settings
SET _Principal=$P = New-ScheduledTaskPrincipal -GroupId Administrators -RunLevel Highest
SET _Trigger=$T = New-ScheduledTaskTrigger -AtLogon
SET _Settings=$S = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
SET _Action=$A = New-ScheduledTaskAction -Execute powershell -Argument \"%_TaskArgs%\"
SET _CreateTask=$C = New-ScheduledTask -Principal $P -Trigger $T -Settings $S -Action $A
SET _RegTask=Register-ScheduledTask -TaskName %_TaskName% -Force -InputObject $C
SET _PSCmds=%_Principal%; %_Trigger%; %_Settings%; %_Action%; %_CreateTask%; %_RegTask%

:: Register configured scheduled task
powershell -command %_PSCmds%

echo Task created.
