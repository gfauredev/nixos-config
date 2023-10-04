let
  ninja = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6wm6k7PfjLQDlVoApJr954OjOl7+a35kS4QzEtQrgr"; # gf@ninja
  gf = [ ninja ]; # All gf user instances
in
{
  "home/gf/secret1.age".publicKeys = gf;
}
