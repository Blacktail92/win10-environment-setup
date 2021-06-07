Get-ChildItem "$PSScriptRoot\registry" | ForEach-Object {
    regedit.exe /s $_
    Write-Output $_ imported successfully.
}
pause