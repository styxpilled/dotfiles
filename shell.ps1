# I don't know where to put this one and this is nasty
iex "$(thefuck --alias)"
oh-my-posh --init --shell pwsh --config C:\Users\styx\AppData\Local\Programs\oh-my-posh\themes\styx.omp.json | Invoke-Expression
Enable-PoshTransientPrompt
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell) -join "`n"
})