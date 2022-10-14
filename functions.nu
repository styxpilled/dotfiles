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