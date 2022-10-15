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

# Initialize a styx-template sveltekit project (styxpilled/styx-template)
def "init styxkit" [
    name: string = ""   # The project name (will prompt if not provided)
    ] {
    let projectname = if $name == "" {
        input $"(ansi green)\u276f "
        | into string
        } else $name
    pnpm dlx degit styxpilled/styx-template $projectname
}

# Initialize a sveltekit project (svelte@latest)
def "init sveltekit" [
    name: string = ""   # The project name (will prompt if not provided)
    ] {
    let projectname = if $name == "" {
        input $"(ansi green)\u276f "
        | into string
        } else $name
    pnpm create svelte@latest $projectname
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