# fish3.1

function sonar \
  --description 'Print path to the fish shell package folder of the caller function'

  set --local caller_function
  # Get caller function name from the stack trace
  set --local stack_trace (status print-stack-trace)[4..-1]

  for line in $stack_trace
    set caller_function (string match --regex 'in function \'([^\']+)\'' $line)[2]
    if test $status -eq 0
      break
    end
  end

  if test -z "$caller_function"
    echo "Error: sonar only works when called within the body of a function"
    return 1
  end

  # Get the path name where the caller function is defined
  set --local caller_pathname (functions --details $caller_function)

  if not contains $caller_pathname $fish_function_path/**.fish
    # Caller is a standalone script, return the caller directory
    echo (dirname -- (realpath $caller_pathname))
    return
  end

  # Locate Fisher configuration folder
  set --query XDG_CONFIG_HOME; or set --local XDG_CONFIG_HOME ~/.config
  set --query fisher_config; or set --local fisher_config $XDG_CONFIG_HOME/fisher

  set --local caller_filename (basename -- $caller_pathname)

  for fisher_pathname in $fisher_config/**.fish
    if test $caller_filename = (basename -- $fisher_pathname)
      # Caller is a Fisher package, return the Fisher package root folder
      echo (realpath (string match --regex (string escape --style=regex -- $fisher_config)'(\\/[^/]*){3}' -- $fisher_pathname)[1])
      return
    end
  end

  # Caller is not a Fisher package, return fish config directory
  echo (realpath $XDG_CONFIG_HOME/fish)
end
