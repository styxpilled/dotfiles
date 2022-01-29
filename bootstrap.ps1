$profileDir = Split-Path -parent $profile
$componentDir = Join-Path $profileDir "components"
$homeDir = Join-Path $profileDir "home"
$tempProfileDir = Join-Path $profileDir "profile.ps1"

New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue
New-Item $componentDir -ItemType Directory -Force -ErrorAction SilentlyContinue

Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"
Copy-Item -Path ./components/** -Destination $componentDir -Include **
Copy-Item -Path ./home/** -Destination $homeDir -Include **

Copy-Item $tempProfileDir -Destination "$profileDir\Microsoft.PowerShell_profile.ps1"
Copy-Item $tempProfileDir -Destination "$profileDir\Microsoft.VSCode_profile.ps1"

Remove-Item -Path $tempProfileDir

Remove-Variable componentDir
Remove-Variable profileDir