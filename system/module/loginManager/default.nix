{ ... }:
{
  # Start window managers at login on firsts TTYs TODO better, in home config
  environment.loginShellInit = builtins.readFile ./loginManager.sh;
}
