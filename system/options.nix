{ lib, ... }:
{
  options = {
    user-def = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything; # TODO type more precisely
      description = "System user(s) definition(s)";
    };
  };
}
