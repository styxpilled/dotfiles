$env.TRANSIENT_PROMPT_COMMAND = ""
$env.PROMPT_COMMAND_RIGHT = ""

let PROMPT_COLOR = { fg: '#908aff' }

$env.PROMPT_INDICATOR = (ansi --escape $PROMPT_COLOR) + "❯ "
$env.PROMPT_COMMAND = {
  (ansi --escape $PROMPT_COLOR) + (pwd
  | str replace ($env.USERPROFILE) '~'
  | str replace -a '\' '/'
  ) + ' ' 
}
