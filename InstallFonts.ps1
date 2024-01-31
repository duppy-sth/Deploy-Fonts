<#
.SYNOPSIS
    Install Fonts on users devices
.DESCRIPTION
    Script will Install all fonts copied inside Fonts directory to a target devicen
.EXAMPLE
    Example of how to use the cmdlet
.EXAMPLE
    Another example of how to use the cmdlet
#>

# SCRIPT NAME: InstallFonts.ps1
# CREATOR: DU
# DATE: 24-7-2023
# UPDATED:
# REFERENCES:

# VARIABLES

# PARAMETERS

#Get all fonts from Fonts Folder
$Fonts = Get-ChildItem .\Fonts
$regpath = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
foreach ($Font in $Fonts) {

    $fontbasename = $font.basename
    If ($Font.Extension -eq '.ttf') { $fontvalue = $Font.Basename + ' (TrueType)' }
    elseif ($Font.Extension -eq '.otf') { $fontvalue = $Font.Basename + ' (OpenType)' }
    else { Write-Host ' Font Extenstion not supported ' -ForegroundColor blue -BackgroundColor white; break }

    $fontname = $font.name 
    if (Test-Path C:\windows\fonts\$fontname) {
        Write-Host "$fontname already exists."
    }
    Else {
        Write-Host "Installing $fontname"
        #Installing Font
        $null = Copy-Item -Path $Font.fullname -Destination 'C:\Windows\Fonts' -Force -EA Stop
    }
    Write-Host 'Creating reg keys...'
    #Creating Font Registry Keys
    $null = New-ItemProperty -Name $fontvalue -Path $regpath -PropertyType string -Value $Font.name -Force -EA Stop    
}
