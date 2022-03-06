# Reload Powershell
# TODO: Make this work
function Reload-Powershell {
  $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
  $newProcess.Arguments = "-nologo";
  [System.Diagnostics.Process]::Start($newProcess);
  exit
}

# Empty the recycle bin
# TODO: Make this work
function Empty-RecycleBin {
  $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
  $RecBin.Items() | %{Remove-Item $_.Path -Recurse -Confirm:$false}
}

# Create a new directory and enter it
function CreateAndSet-Directory([String] $path) { New-Item $path -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $path}

# Convert a number to a disk size (12.4K or 5M)
function Convert-ToDiskSize {
    param ( $bytes, $precision='0' )
    foreach ($size in ("B","K","M","G","T")) {
        if (($bytes -lt 1000) -or ($size -eq "T")){
            $bytes = ($bytes).tostring("F0" + "$precision")
            return "${bytes}${size}"
        }
        else { $bytes /= 1KB }
    }
}

# Determine size of a file or total size of a directory
function Get-DiskUsage([string] $path=(Get-Location).Path) {
    Convert-ToDiskSize `
        ( `
            Get-ChildItem .\ -recurse -ErrorAction SilentlyContinue `
            | Measure-Object -property length -sum -ErrorAction SilentlyContinue
        ).Sum `
        1
}

function CreateImageVariants([string] $fileName) {
  $baseName = $fileName.Substring(0,$fileName.LastIndexOf('.')).split('\')[-1]
  $extension = $fileName.Substring($fileName.LastIndexOf('.'), $fileName.length - $fileName.LastIndexOf('.'))
  $size = 8
  $tempsize = $size
  $odd = 0
  while($size -lt 128) {
    if ($odd) {
      $tempsize = $size + ($size / 2)
    }
    else {
      $tempsize = $size * 2
      $size = $size * 2
    }
    $odd = !$odd
    Write-Host "$baseName$tempsize$extension"
    magick convert $fileName -resize $tempsize "$baseName$tempsize$extension"
  }
}

function whatsmyip {
  (Invoke-WebRequest ifconfig.me/ip).Content.Trim()
}

function whatstheweather ([string] $city) {
  $url = "wttr.in/" + $city
  (Invoke-WebRequest $url).Content.Trim()
}

function whatstheweathershort ([string] $city) {
  $url = "wttr.in/" + $city + "?format=3"
  (Invoke-WebRequest $url).Content.Trim()
}

function howto(
  [ValidateSet(
    'addfiletogit',
    'fixcommitdate',
    'fixcommitmessage',
    'makesveltekit',
    'makestyx',
    'commitizencommit',
    $null 
  )] $question) {
  $answers = @{
    addfiletogit =
    @('add a file to the git repository','git add package.json');
    fixcommitdate =
    @('fix the commit date',"git commit --amend --no-edit --date `"$(Get-Date -Format 'ddd dd MMM yyyy HH:mm:ss K')`"");
    fixcommitmessage =
    @('fix the commit message','git commit --amend --no-edit --message "Fix commit message"');
    makesveltekit = 
    @('make a sveltekit project','npm init @svelte-add/kit@latest');
    makestyx =
    @('make a styx project','npx degit styxpilled/styx-template');
    commitizencommit =
    @('make a commitizen commit','npx cz');
  }
  if ($question -eq $null) {
    Write-Host "Usage: howto <question>" -ForegroundColor Green
    Write-Host "Available questions: " -ForegroundColor Green
    Write-Output $answers
  }
  else {
    if ($answers.Contains($question)) {
      Write-Host "How to $($answers[$question][0]):" -ForegroundColor Green
      Write-Host $answers[$question][1] -ForegroundColor Green
      Set-Clipboard $answers[$question][1]
    }
    else {
      Write-Host "Invalid question. Available questions: " -ForegroundColor Red
      Write-Output $answers
    }
  }
}

function conventionalcommits() {
  Write-Host "feat" -ForegroundColor Green -NoNewline
  Write-Host ": Commits, that adds a new feature"
  Write-Host "fix" -ForegroundColor Green -NoNewline
  Write-Host ": Commits, that fixes a bug"
  Write-Host "refactor" -ForegroundColor Green -NoNewline
  Write-Host ": Commits, that rewrite/restructure your code, however does not change any behaviour"
  Write-Host "perf" -ForegroundColor Green -NoNewline
  Write-Host ": Commits are special refactor commits, that improves performance"
  Write-Host "style" -ForegroundColor Green -NoNewline
  Write-Host ": Commits, that do not affect the meaning (white-space, formatting, missing semi-colons, etc)"
  Write-Host "test" -ForegroundColor Green -NoNewline
  Write-Host ": Commits, that add missing tests or correcting existing tests"
  Write-Host "docs" -ForegroundColor Green -NoNewline
  Write-Host ": Commits, that affect documentation only"
  Write-Host "build" -ForegroundColor Green -NoNewline
  Write-Host ": Commits, that affect build components like build tool, ci pipeline, dependencies, project version"
  Write-Host "ops" -ForegroundColor Green -NoNewline
  Write-Host ": Commits, that affect operational components like infrastructure, deployment, backup, recovery"
  Write-Host "chore" -ForegroundColor Green -NoNewline
  Write-Host ": Miscellaneous commits e.g. modifying .gitignore"
}