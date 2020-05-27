# fish3.1

# Fishtape run tests in sub-shells, so we cannot define the caller function there,
# otherwise it will be reported as defined at `stdin` by fish
function sonar_caller
  sonar
end
