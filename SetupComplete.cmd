@echo off

:: log file
set _log_file=%temp%\SetupComplete_errors.log

:: location of file to be executed (url must be raw)
set _file=https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10Debloater.ps1

:: task settings
set _TaskName="Windows Environment Setup"
set _TaskArgs=Invoke-Expression((New-Object System.Net.WebClient).DownloadString('%_file%')); Unregister-ScheduledTask -TaskName '%_TaskName%' -Confirm:`$false
set _Principal=$P=New-ScheduledTaskPrincipal -GroupId Administrators -RunLevel Highest
set _Trigger=$T=New-ScheduledTaskTrigger -AtLogon
set _Settings=$S=New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
set _Action=$A=New-ScheduledTaskAction -Execute powershell -Argument \"%_TaskArgs%\"
set _CreateTask=$C=New-ScheduledTask -Principal $P -Trigger $T -Settings $S -Action $A
set _RegTask=Register-ScheduledTask -TaskName '%_TaskName%' -Force -InputObject $C

call:_start_logging 2>%_log_file%

:_start_logging
:: check elevation
openfiles >nul
if %errorlevel% neq 0 call:_exit

:: delete task if exists
schtasks /query /tn %_TaskName% >nul 2>&1
if %errorlevel% equ 0 (
    echo Removing existing task...
    schtasks /delete /f /tn %_TaskName% >nul
    if %errorlevel% equ 0 echo Task removed.
)

:: create and register task
echo Creating scheduled task...
powershell -command %_Principal%; %_Trigger%; %_Settings%; %_Action%; %_CreateTask%; %_RegTask% >nul
if %errorlevel% equ 0 echo Task created.

:: check if registered
schtasks /query /tn %_TaskName% >nul
if %errorlevel% equ 0 echo Task registered.

:_exit
:: check error logs and print result
for %%G in (%_log_file%) do set _log_size=%%~zG)
if %_log_size% equ 0 (
    echo Operation successful.
) else (
    echo Something went wrong, log file: %_log_file% & echo:
    type %_log_file%
    timeout /t 3 >nul 2>&1 & exit
)
