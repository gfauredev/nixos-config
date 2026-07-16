{ config, ... }: {
  programs.vicinae.enable = true;

  programs.vicinae.enableFirefoxIntegration = true;

  # programs.vicinae.extensions = [
  #   (config.lib.vicinae.mkExtension {
  #     name = "test-extension";
  #     npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "schromp";
  #         repo = "vicinae-extensions";
  #         rev = "f8be5c89393a336f773d679d22faf82d59631991";
  #         sha256 = "sha256-zk7WIJ19ITzRFnqGSMtX35SgPGq0Z+M+f7hJRbyQugw=";
  #       }
  #       + "/test-extension";
  #   })
  #   (config.lib.vicinae.mkRayCastExtension {
  #     name = "gif-search";
  #     sha256 = "sha256-G7il8T1L+P/2mXWJsb68n4BCbVKcrrtK8GnBNxzt73Q=";
  #     rev = "4d417c2dfd86a5b2bea202d4a7b48d8eb3dbaeb1";
  #     npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #   })
  #   See https://docs.vicinae.com/extensions/introduction
  # ];

  # programs.vicinae.settings = { See https://docs.vicinae.com/config };

  xdg.configFile.vicinae = {
    "settings.json.mutable" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/vicinae/settings.json";
    };
  };

  programs.vicinae.systemd.enable = true;
  programs.vicinae.systemd.autoStart = true;

  # programs.vicinae.themes = { managed by stylix };
}
