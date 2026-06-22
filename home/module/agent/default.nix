{ config, ... }: {
  config.home.file = {
    ".gemini/antigravity-cli/settings.link.json".source =
      config.lib.file.mkOutOfStoreSymlink # br
        "${config.location}/public/home/module/agent/antigravity/settings.json";
    ".gemini/antigravity-cli/keybindings.json".source =
      config.lib.file.mkOutOfStoreSymlink # br
        "${config.location}/public/home/module/agent/antigravity/keybindings.json";
  };
}
