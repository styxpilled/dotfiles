# Initialize paths
$profileDir = Split-Path -parent $profile
$componentDir = Join-Path $profileDir "components"
$homeDir = Join-Path $profileDir "home"
$licenseDir = Join-Path $profileDir "licenses"
$tempProfileDir = Join-Path $profileDir "profile.ps1"
# I don't know
New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue
# New-Item $componentDir -ItemType Directory -Force -ErrorAction SilentlyContinue
New-Item $licenseDir -ItemType Directory -Force -ErrorAction SilentlyContinue
# Copy all files from the dev directory to the profile directory
Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"
# Copy-Item -Path ./components/** -Destination $componentDir -Include **
Copy-Item -Path ./licenses/** -Destination $licenseDir -Include **
# Copy-Item -Path ./home/** -Destination $homeDir -Include **
# Create profile files from profile.ps1
Copy-Item $tempProfileDir -Destination "$profileDir\Microsoft.PowerShell_profile.ps1"
Copy-Item $tempProfileDir -Destination "$profileDir\Microsoft.VSCode_profile.ps1"
# Remove profile.ps1
Remove-Item -Path $tempProfileDir
# Clear unnecessary variables
Remove-Variable componentDir
Remove-Variable profileDir