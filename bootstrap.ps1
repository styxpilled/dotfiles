# Initialize path
$profileDir = Split-Path -parent $profile

# replace existing profile with dotfile profile for powershell and vscode powershell
Copy-Item -Path "./profile.ps1" -Destination "$profileDir\Microsoft.PowerShell_profile.ps1"
Copy-Item -Path "./profile.ps1" -Destination "$profileDir\Microsoft.VSCode_profile.ps1"

# Clear unnecessary variables
Remove-Variable profileDir