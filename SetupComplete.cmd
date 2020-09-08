@echo off

:: Check elevation
openfiles>nul 2>&1
if %ERRORLEVEL% neq 0 (
    exit /B %ERRORLEVEL%
)

:: Variables
set /A _error_code=0
set _log_file=c:/logs.txt

:: Raw URL of the powershell script to be executed
set _URL=https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10Debloater.ps1

:: Task settings
set _TaskName="Windows Environment Setup"
set _TaskArgs=Invoke-Expression((New-Object System.Net.WebClient).DownloadString('%_URL%')); Unregister-ScheduledTask -TaskName '%_TaskName%' -Confirm:`$false
set _Principal=$P=New-ScheduledTaskPrincipal -GroupId Administrators -RunLevel Highest
set _Trigger=$T=New-ScheduledTaskTrigger -AtLogon
set _Settings=$S=New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
set _Action=$A=New-ScheduledTaskAction -Execute powershell -Argument \"%_TaskArgs%\"
set _CreateTask=$C=New-ScheduledTask -Principal $P -Trigger $T -Settings $S -Action $A
set _RegTask=Register-ScheduledTask -TaskName '%_TaskName%' -Force -InputObject $C

:: Delete task if exists
schtasks /QUERY /TN %_TaskName%>nul 2>>%_log_file%
if %ERRORLEVEL% equ 0 (
    echo Removing existing task...
    schtasks /DELETE /F /TN %_TaskName%>nul 2>>%_log_file%
)

:: Create and register task
echo Creating scheduled task...
powershell -command %_Principal%; %_Trigger%; %_Settings%; %_Action%; %_CreateTask%; %_RegTask%>nul 2>>%_log_file%
if %ERRORLEVEL% neq 0 (
    set /A _error_code=1
)
:: Check if registered
schtasks /QUERY /TN %_TaskName%>nul 2>>%_log_file%
if %ERRORLEVEL% neq 0 (
    set /A _error_code=1
)

:: Print result
if %_error_code% equ 0 (
    echo Task created successfully.
) else (
    echo Error! Log file: %_log_file%
)
