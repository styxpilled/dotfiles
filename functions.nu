# Prints the conventional commits info
def conventionalcommits [] {
    print $"(ansi green)feat(ansi reset): add a new feature
(ansi green)fix(ansi reset): fix a bug
(ansi green)refactor(ansi reset): rewrite/restructure that does not change any behaviour
(ansi green)perf(ansi reset): refactor commits that improve performance
(ansi green)style(ansi reset): white-space, formatting, missing semi-colons, etc
(ansi green)test(ansi reset): add missing tests or correcting existing tests
(ansi green)docs(ansi reset): change documentation only
(ansi green)build(ansi reset): build tool, ci pipeline, dependencies, project version
(ansi green)build\(deps\)(ansi reset): bump dependencies
(ansi green)ops(ansi reset): infrastructure, deployment, backup, recovery
(ansi green)chore(ansi reset): miscellaneous, e.g. modifying .gitignore"
}

# Go to a directory with zoxide an open vscode there
def zc [
    dir: string     # The directory name
    ] {
    cd (zoxide query -- $dir)
    code .
    exit
}

# Open a directory in File Explorer (defaults to .)
def browse [
    dir: string = "."   # The directory name (defaults to .)
    ] {
    ^start $dir
}

# Open a directory or file in Visual Studio Code (defaults to .) and exit
def vsc [
    dir: string = "."   # The directory or file name (defaults to .)
    ] {
    cd (zoxide query -- $dir)
    code .
    exit
}

# Put something into clipboard
export def clip [
  --silent (-s) # Don't print anything
] {
    let input = $in
    let input = if ($input | describe) == "string" {
        $input | ansi strip
    } else { $input }

    $input | clip.exe

    if (not $silent) {
      print $input

      print --no-newline $"(ansi white_italic)(ansi white_dimmed)saved to clipboard"
      if ($input | describe) == "string" {
          print --no-newline " (stripped)"
      }
      print --no-newline $"(ansi reset)"
    }
}

# initial git push -u origin main
def gpuom [] {
    git push -u origin main
}

# git push origin main
def gpom [] {
    git push origin main
}

# git log that works with nushell tables
def git-log [
    count:int = 30
    ] {
    let commits = (git log -n $count --format="%s // %h // %ae // %aI"
    | lines
    | split column " // " msg commit author date
    | each {|row| update date ($row.date | into datetime)}
    | each {|row| update author ($row.author | split row "@" | $in.0)}
    | each {|row|
      insert type (
          if $row.msg =~ '.+: .+' {
            if $row.msg =~ '.+\(.+\): .+' {
              $row.msg | parse "{type}({scope}): {message}"
            } else {
              $row.msg | parse "{type}: {message}"
            }
          } else {
            $row.msg
          }
        )  
      }
    | reject msg
    | move type --after commit
    | flatten -a)

    $commits
}

# Get uptime
def uptime [] {
    sys | get host | get uptime
}

# Print history lines
def printhistory [
    count: int = 25  # How many lines to print
    ] {
    history
    | last $count
    | update command {|f|
        $f.command 
        | nu-highlight
        }
}

# Convert videos to mp4
def "file convert video" [
  input: string
  --output (-o): string = ""
  --format (-f): string = "mp4"
  ] {
  let newname = if $output == "" {
    ($input | str substring 0..($input | str index-of "." -e))
  } else {
    $output
  }
  ffmpeg -hide_banner -hwaccel cuda -i $input $"($newname).($format)" 
}

# Extract audio stream from video
def "file convert audio" [
  input: string
  --output (-o): string = ""
  --format (-f): string = "mp3"
  ] {
    let newname = ($input | str substring 0..($input | str index-of "." -e))
    ffmpeg -hide_banner -i $input -q:a 0 -map a $"($newname).($format)" 
}

# Convert videos to gif
def "file convert gif" [
  input: string
  --output (-o): string = ""
  --format (-f): string = "gif"
  ] {
    let newname = ($input | str substring 0..($input | str index-of "." -e))
    ffmpeg -hide_banner -i $input -vf "fps=10,scale=640:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 $"($newname).($format)"
}

# Convert pdfs to images
def "file convert pdf" [
  input: string
  --output (-o): string = ""
  --format (-f): string = "jpg"
  ] {
  let newname = ($input | str substring [0 ($input | str index-of "." -e)])
  print $newname $format
  gswin64 -dNOPAUSE -dBATCH -r96 -sDEVICE=jpeg $"-sOutputFile=($newname).($format)" -dLastPage=1 $input
}

# Get the weather forecast
def wtw [
  city: string = ""           # The city you want to look up (defaults to your current city)
  --format (-f): int = -1     # The one-line format (defaults to no format)
  ] {
  let options =  if $format != -1 { $"&format=($format)" }
  curl $"wttr.in/($city)?F($options)"
}

# Get your public IPv4 address
def whatsmyip [] {
    curl ifconfig.me/ip
}

# SEMVER bump package.json
def bump [
    --type (-t): int = 1    # 0 = major; 1 = minor; 2 = patch;
    ] {
    open package.json 
        | update version (($in.version
        | split row ".")
        | update $type (
            ($in | get $type)
            | into int 
            | $in + 1)
        | str join ".")
        | save package.json
}

# SEMVER bump MAJOR package.json (X+1.0.0)
def "bump major" [] {
    bump -t 0
}

# SEMVER bump MINOR package.json (0.X+1.0)
def "bump minor" [] {
    bump -t 1
}

# SEMVER bump PATCH package.json (0.0.X+1)
def "bump patch" [] {
    bump -t 2
}

# Initialize a typescript project
def "init ts" [
    name: string = ""   # The project name (defaults to the current directory name)
    ] {
    let projectname = if $name == "" {
        $env.PWD
        | split row "\\"
        | get (
            ($in
            | length) - 1)
        } else $name
    {
        name: $projectname
        version: "0.1.0"
        description: ""
        main: "dist/index.js"
        scripts: {
            test: "tsc && node dist/test.js"
            dev: "tsc && node dist/index.js"
        }
        keywords: []
        author: ""
        license: "ISC"
        dependencies: {}
    } | save package.json
    {
        compilerOptions: {
            module: "commonjs",
            outDir: "dist/"
        }
        exclude: [
            "node_modules"
        ]
    } | save tsconfig.json
    mkdir src
    touch src/index.ts
}

def "h2 psql" [] {
  # "psql -h localhost -p 5432 -U username default_database -W"
  print "psql -h <REMOTE HOST> -p <REMOTE PORT> -U <DB_USER> <DB_NAME> -W"
}

def "compose down" [] {
  docker compose -f "docker-compose.yml" down
}

def "prompt confirmation" [
    default: bool = true,
    message: string = "Are you satisfied?"
    ] {
    let can_proceed = (input $"($message) y/N ")
    if (($can_proceed | str downcase) == "y") {
      return true
    } else {
      return false
    }
}

# Reminder on how to ammend commit date
def "h2 git date" [
    time: duration = 0day   # Amount of time to shift from date now
    --positive (-p)         # Add the date instead of subtracting
    --manual (-m)           # Put the command in the clipboard instead of runnning it
    --confirm (-c)          # Skip confirmation screen
    ] {
    let amendtime = (date now | if ($positive) { $in + $time } else { $in - $time } | format date $"%c")

    if ($manual) {
      print $"git commit --amend --no-edit --date \"($amendtime)\""
      $"git commit --amend --no-edit --date \"($amendtime)\"" | clip -s
    } else {
      if ($confirm) {
        git commit --amend --no-edit --date $"($amendtime)"
      } else {
        print $"git commit --amend --no-edit --date \"($amendtime)\""
        let can_proceed = (prompt confirmation)
        if (($can_proceed | str downcase) == "y") {
          git commit --amend --no-edit --date $"($amendtime)"
        } else {
          print "Aborting..."
        }
      }
    }
}

# Reminder on how to ammend commit message
def "h2 git message" [
    input: string = "Commit message here"
    --prompt (-p)           # Prompt for input
    --manual (-m)           # Put the command in the clipboard instead of runnning it
    --confirm (-c)          # Skip confirmation screen
    ] {
      # @('fix the commit message', "git commit --amend --no-edit --message `"$(iif $param $param 'Commit message here')`"");
    
    let message = if ($input == "Commit message here" and $prompt) { (input "What do you want the commit message to be? ") } else {
      $input
    }

    if ($manual) {
      print $"git commit --amend --no-edit --message \"($message)\""
      $"git commit --amend --no-edit --message \"($message)\"" | clip -s
    } else {
      if ($confirm) {
        git commit --amend --no-edit --message $"($message)"
      } else {
        print $"git commit --amend --no-edit --message \"($message)\""
        let can_proceed = (input "Are you satisfied? Y/n ")
        if ($can_proceed == "Y") {
          git commit --amend --no-edit --message $"($message)"
        } else {
          print "Aborting..."
        }
      }
    }
}

def "h2 keybindings" [] {
  print {
    'F1': 'Help menu'
    'CTRL + R': 'History menu'
    'CTRL + C': 'Cancel command'
    'CTRL + L': 'Clear screen'
    'CTRL + Q': 'Interactive search history'
    'CTRL + A': 'Move to line start'
    'CTRL + E': 'Move to line end'
  }
}

def "typeof getlicense" [] { ls -s '~/dotfiles/licenses' | $in.name }
def getlicense [
    license: string@"typeof getlicense"
    --silent (-s)
    ] {
    if (not $silent) { print $"Copying license ($license) to ($env.PWD | path join "LICENSE")" }
    $"~/dotfiles/licenses/($license)" | path expand | cp $in ./LICENSE
}