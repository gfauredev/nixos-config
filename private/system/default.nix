{ config, lib, ... }: # Example private system configuration
{
  # Create the default user from its private definition (see ../user.nix)
  users.users.${config.user-def.users.default.name} = lib.mapAttrs (_: lib.mkDefault) (
    config.user-def.users.default
  );
}
