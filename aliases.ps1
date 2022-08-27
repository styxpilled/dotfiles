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
function dwn { z D:\dwn }
function cdl { z ~\Downloads }

# Get file info
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }

# Close Powershell
Set-Alias close ClosePowerShell
Set-Alias quit ClosePowerShell

# Git Push Origin Main
Set-Alias gpom GitPushOriginMain

# Time the speed of commands
Set-Alias time Measure-Command

# Create a new directory and enter it
Set-Alias mkd CreateAndSetDirectory

# Advanced remove
Set-Alias arm RemoveFilesMatchingRegex

# Create a new file
Set-Alias touch ni

# Open the folder in File Explorer
Set-Alias open ii

# Clear the screen
Set-Alias c clear

# Neofetch but worse
Set-Alias winfetch "pwshfetch-test-1"

# Check public IP
Set-Alias wip whatsmyip

# Check the weather, long form
Set-Alias wtw whatstheweather

# Check the weather, short form
Set-Alias wtws whatstheweathershort