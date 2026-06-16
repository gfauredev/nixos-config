{ config, ... }: {
  config.home.file = {
    "~/.gemini/antigravity-cli/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink # br
        "${config.location}/public/home/module/antigravity/settings.json";
    "~/.gemini/antigravity-cli/keybindings.json".source =
      config.lib.file.mkOutOfStoreSymlink # br
        "${config.location}/public/home/module/antigravity/keybindings.json";
  };
}
