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
def zc [dir: string] {
    __zoxide_z $dir
    code .
}

# git push origin main
def gpom [] {
    git push -u origin main
}

# Get the weather forecast
def wtw [city: string = ""] {
    curl $"wttr.in/($city)"
}

# Get the weather forecast in short format
def wtws [city: string = ""] {
    curl $"wttr.in/($city)?format=3"
}

# Get your public IPv4 address
def whatsmyip [] {
    curl ifconfig.me/ip
}

# Open a directory in File Explorer (defaults to .)
def oe [dir: string = "."] {
    ^start $dir
}