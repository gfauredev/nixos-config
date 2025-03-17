{ ... }: {
  # Start window managers at login on firsts TTYs
  environment.loginShellInit = builtins.readFile ./loginManager.sh;
}
