@echo off

:: Check elevation
openfiles > NUL 2>&1
if %ERRORLEVEL% EQU 1 (
    echo Elevation required!
    exit /B %ERRORLEVEL%
)

:: Raw URL of the powershell script to be executed
set _URL=https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10Debloater.ps1

:: Task name and arguments
set _TaskName=env_setup
set _TaskArgs=Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('%_URL%')); Unregister-ScheduledTask -TaskName %_TaskName% -Confirm:`$false

:: Task settings
set _Principal=$P=New-ScheduledTaskPrincipal -GroupId Administrators -RunLevel Highest
set _Trigger=$T=New-ScheduledTaskTrigger -AtLogon
set _Settings=$S=New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
set _Action=$A=New-ScheduledTaskAction -Execute powershell -Argument \"%_TaskArgs%\"
set _CreateTask=$C=New-ScheduledTask -Principal $P -Trigger $T -Settings $S -Action $A
set _RegTask=Register-ScheduledTask -TaskName %_TaskName% -Force -InputObject $C
set _PSCmds=%_Principal%; %_Trigger%; %_Settings%; %_Action%; %_CreateTask%; %_RegTask%

:: Delete task if exists
schtasks /QUERY /TN %_TaskName% > NUL 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Removing existing task...
    schtasks /DELETE /F /TN %_TaskName% > NUL 2>&1
)

:: Create and register task
echo Creating scheduled task...
powershell -command %_PSCmds% > NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
    REM set /A _error_task_created=1
)

:: Check if registered
schtasks /QUERY /TN %_TaskName% > NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
    set /A _error_task_registered=1
)

:: Check for errors
set /A _error_code=_error_task_created+_error_task_registered
if %_error_code% EQU 0 (
    echo Task created successfully.
) else (
    echo Error!
    exit /B %ERRORLEVEL%
)
