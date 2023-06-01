# This file is a template intended to be copied into a file named
# private.nix
# containing the right configuration values

{ config, pkgs, ... }:

{
  users.users = {
    gf = {
      hashedPassword = "$0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
      #cryptHomeLuks = "/dev/mapper/crypthome"; # TODO, eventually with homed
    };
  };
}
