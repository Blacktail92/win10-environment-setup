fixed array olustur en basta itemları ona yaz wildcard ile
fonksiyonlar: is_feature, is_capability

for loop
    resolve name
    if_capability
        Add-WindowsCapability
    if_feature
        Enable-WindowsOptionalFeature
    else
        write-host no such feature found!


New-ItemProperty -Path "HKCU:\dummy\NetwrixKey" -Name "NetwrixParam" -Value ”NetwrixValue”  -PropertyType "String"