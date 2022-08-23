$env:PYTHONIOENCODING="utf-8"
$profileDir = Split-Path -parent $profile
$componentDir = Join-Path $profileDir "components"
$profileFiles = @("aliases", "functions", "shell")

$dotfiles = "C:\Users\styx\dotfiles"

for ($i=0; $i -lt $profileFiles.Length; $i++) {
  $profileFile = Join-Path $profileDir "$($profileFiles[$i]).ps1"
  Import-Module -Name  $profileFile
}

Remove-Variable componentDir
Remove-Variable profileDir
Remove-Variable profileFiles

Clear-Host