# fish3.1

source $current_dirname/../functions/sonar.fish
set --query XDG_CONFIG_HOME; or set --local XDG_CONFIG_HOME ~/.config

source $current_dirname/sonar_caller/functions/sonar_caller.fish
@test "print path for a standalone script" (
  sonar_caller
) = (realpath $current_dirname/sonar_caller/functions)
functions --erase sonar_caller

fish -c 'fisher add '(realpath $current_dirname/sonar_caller) &>/dev/null
source $XDG_CONFIG_HOME/fish/functions/sonar_caller.fish
@test "print path for a Fisher package" (
  sonar_caller
) = (realpath $current_dirname/sonar_caller)
fish -c 'fisher rm '(realpath $current_dirname/sonar_caller) &>/dev/null

cp $current_dirname/sonar_caller/functions/sonar_caller.fish $XDG_CONFIG_HOME/fish/functions/sonar_caller.fish
source $XDG_CONFIG_HOME/fish/functions/sonar_caller.fish
@test "print path for a manually installed function" (
  sonar_caller
) = (realpath $XDG_CONFIG_HOME/fish)
functions --erase sonar_caller
rm $XDG_CONFIG_HOME/fish/functions/sonar_caller.fish
