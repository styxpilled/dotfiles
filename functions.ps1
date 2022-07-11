function ClosePowerShell {
  exit
}

# Create a new directory and enter it
function CreateAndSetDirectory([String] $path) { New-Item $path -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $path }

function CreateImageVariants([string] $fileName) {
  $baseName = $fileName.Substring(0, $fileName.LastIndexOf('.')).split('\')[-1]
  $extension = $fileName.Substring($fileName.LastIndexOf('.'), $fileName.length - $fileName.LastIndexOf('.'))
  $size = 8
  $tempsize = $size
  $odd = 0
  while ($size -lt 128) {
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

# Git push origin main
function GitPushOriginMain {
  git push origin main
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

function videotogif([string] $video, [string] $gif = $video.Substring(0, $video.LastIndexOf('.'))) {
  ffmpeg -i $video -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$gif.gif"
}

function GetFilesMatchingRegex([string] $reg) {
  Get-ChildItem $Path | Where-Object { $_.Name -Match $reg }
}

function RemoveFilesMatchingRegex([string] $reg) {
  Get-ChildItem $Path | Where-Object { $_.Name -Match $reg } | Remove-Item
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
  )] $question,
  [string] $param) {
  $answers = @{
    addfiletogit     =
    @('add a file to the git repository', 'git add package.json');
    fixcommitdate    =
    @('fix the commit date', "git commit --amend --no-edit --date `"$((Get-Date).AddDays($(iif [bool]($param -as [int]) $param 0)).ToString('ddd dd MMM yyyy HH:mm:ss K'))`"");
    fixcommitmessage =
    @('fix the commit message', "git commit --amend --no-edit --message `"$(iif $param $param 'Commit message here')`"");
    makesveltekit    = 
    @('make a sveltekit project', 'npm init @svelte-add/kit@latest');
    makestyx         =
    @('make a styx project', 'npx degit styxpilled/styx-template');
    commitizencommit =
    @('make a commitizen commit', 'npx cz');
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

function iif($if, $IfTrue, $IfFalse) {
  if ($if) { If ($IfTrue -is "ScriptBlock") { &$IfTrue } Else { $IfTrue } }
  Else { If ($IfFalse -is "ScriptBlock") { &$IfFalse } Else { $IfFalse } }
}

function getlicense(
  [ValidateSet(
    'mit',
    'apache',
    'gplv3',
    'lgplv3',
    'mplv2',
    'bsd2',
    'bsd3',
    $null 
  )] $license) {
  $licenses = @{
    mit    = "./licenses/MIT";
    apache = "./licenses/APACHE";
    gplv3  = "./licenses/GPLv3";
    lgplv3 = "./licenses/LGPLv3";
    mplv2  = "./licenses/MPLv2";
    bsd2   = "./licenses/BSD2-CLAUSE";
    bsd3   = "./licenses/BSD3-CLAUSE";
  };
  if ($license -eq $null) {
    Write-Host "Usage: license <license>" -ForegroundColor Green
    Write-Host "Available licenses: " -ForegroundColor Green
    Write-Output $licenses
  }
  else {
    $license_file = $licenses[$license]
    if (-not (Test-Path $license_file)) {
      Write-Host "License $license not found" -ForegroundColor Red
    }
    else {
      Write-Output "Copying license $license to ./LICENSE"
      Copy-Item $license_file ./LICENSE -Force
    }
  }
}