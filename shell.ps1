
if ($PSVersionTable.PSVersion.Major -gt 6) {
  Invoke-Expression "$(thefuck --alias)"
  oh-my-posh --init --shell pwsh --config C:\Users\styx\AppData\Local\Programs\oh-my-posh\themes\styx.omp.json | Invoke-Expression
  Enable-PoshTransientPrompt

  Import-Module PSReadLine
  Set-PSReadLineOption -PredictionSource History
}
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell) -join "`n"
  })
