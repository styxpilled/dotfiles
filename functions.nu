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
    __zoxide_z $dir
    code .
}

# initial git push -u origin main
def gpuom [] {
    git push -u origin main
}

# git push origin main
def gpom [] {
    git push origin main
}

# Get uptime
def uptime [] {
    sys | get host | get uptime
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

# Open a directory in File Explorer (defaults to .)
def oe [
    dir: string = "."   # The directory name (defaults to .)
    ] {
    ^start $dir
}

# Open a directory or file in Visual Studio Code (defaults to .)
def oc [
    dir: string = "."   # The directory or file name (defaults to .)
    ] {
    code $dir
}

# Open a directory or file in Visual Studio Code (defaults to .) and exit
def oce [
    dir: string = "."   # The directory or file name (defaults to .)
    ] {
    code $dir
    exit
}