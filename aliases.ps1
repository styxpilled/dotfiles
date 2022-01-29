$PSV = Get-Host | Select-Object Version

# Enable zoxide
Set-Alias z __zoxide_z -Option AllScope
Set-Alias zi __zoxide_zi -Option AllScope

# Navigation Shortcuts
function ~ { z ~ }
function .. { z .. }
function ... { z ..\.. }
function .... { z ..\..\.. }
# ---------------------------------------------------------
function dt { z ~\Desktop }
function docs { z ~\Documents }
function dl { z D:\Downloads }
function cdl { z ~\Downloads }
function cde { z D:\Code }

# Get file info
# TODO: make this work
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }

# Time the speed of commands
Set-Alias time Measure-Command

# Create a new directory and enter it
Set-Alias mkd CreateAndSet-Directory

# Determine size of a file or total size of a directory
Set-Alias fs Get-DiskUsage

# Empty the Recycle Bin on all drives
Set-Alias emptytrash Empty-RecycleBin

# Reload the shell
Set-Alias reload Reload-Powershell

# Create a new file
Set-Alias touch ni

# Open the folder in File Explorer
Set-Alias open ii

# Clear the screen
Set-Alias c clear

# Use PowerColorLS for LS
Remove-Alias ls -Force 
Set-Alias ls PowerColorLS

# Neofetch but worse
Set-Alias winfetch "pwshfetch-test-1"