{ lib, ... }:
{
  i18n.defaultLocale = lib.mkDefault "en_GB.UTF-8";
  i18n.extraLocaleSettings =
    let
      fr = "fr_FR.UTF-8";
    in
    {
      # LANG = fr;
      # LANGUAGE = fr;
      LC_ADDRESS = fr;
      # LC_ALL = fr;
      LC_IDENTIFICATION = fr;
      # LC_MESSAGES = fr;
      LC_MEASUREMENT = fr;
      LC_MONETARY = fr;
      LC_NAME = fr;
      LC_NUMERIC = fr;
      LC_PAPER = fr;
      LC_TELEPHONE = fr;
      LC_TIME = fr;
    };
}
