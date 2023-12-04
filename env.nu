# Nushell Environment Config File

$env.dotfiles = ([$nu.home-path, "dotfiles"] | path join)

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# node turborepo preserve console.log color
$env.FORCE_COLOR = 1

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# STARSHIP
oh-my-posh init nu --config ~\dotfiles\theme\styx.omp.json

# Importing all the sub modules
source ~/dotfiles/functions.nu
source ~/dotfiles/aliases.nu

# ZOXIDE
# zoxide init nushell --hook prompt | save -f ~/.cache/zoxide/.zoxide.nu


# let-env STARSHIP_CONFIG = 'C:/Users/styx/dotfiles/config/starship.toml'
# mkdir ~/.cache/starship
# starship init nu | save ~/.cache/starship/init.nu