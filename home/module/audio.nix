{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}: # Audio and Music production and consumption
{
  services = {
    playerctld.enable = true;
    mpris-proxy.enable = true;
  };

  home.sessionVariables =
    let
      pluginPath =
        dir:
        "${config.user.home}/.${dir}:"
        + (lib.makeSearchPath dir [
          "${config.user.home}/.nix-profile/lib"
          # "/run/current-system/sw/lib"
          # "/etc/profiles/per-user/${config.user.name}/lib"
        ]);
    in
    {
      CLAP_PATH = lib.mkDefault (pluginPath "clap");
      DSSI_PATH = lib.mkDefault (pluginPath "dssi");
      LADSPA_PATH = lib.mkDefault (pluginPath "ladspa");
      LV2_PATH = lib.mkDefault (pluginPath "lv2");
      LXVST_PATH = lib.mkDefault (pluginPath "lxvst");
      VST3_PATH = lib.mkDefault (pluginPath "vst3");
      VST_PATH = lib.mkDefault (pluginPath "vst");
    };

  home.packages = with pkgs; [
    # ardour # Full fledged digital audio workstation
    pkgs-unstable.bespokesynth # Software modular synth, controllers support
    carla # VST Host & audio router
    cardinal # Standalone and VST modular synthesizer
    # giada # Live electronic music platform
    glicol-cli # Music live coding
    helio-workstation # Sequencer / DAW
    helvum # Modular audio environment
    # ingen # Modular audio environment
    # ossia-score # Interactive sequencer
    # patchage # JACK router
    # qpwgraph # PipeWire router
    # supercollider # Audio synthesis and algorithmic composition
    # vcv-rack # Standalone modular synthesizer
    # vmpk # Virtual keyboard
    # DAW & Editors
    # audacity # Simple audio editor
    musescore # Music writing
    neothesia # MIDI piano roll player
    # zrythm # Modern digital audio workstation
    # Plugin (VST…)
    # bristol # Synths collection
    # calf # Collection of audio plugins
    distrho-ports # Collection of audio plugins, contains Vitalium
    # drumgizmo # High quality drums sampler
    # iannix # Graphical sequencer
    surge-XT # Great hybrid substractive synth
    # stochas # Polyrithmic sequencer
    # lsp-plugins # Collection of audio plugins
    # zam-plugins # A collection of LV2/LADSPA/VST/JACK plugins
    # infamousPlugins # Collection of audio plugins
    # Bridges & Drivers & Adapters
    # airwave # WINE-based VST bridge for Linux VST hosts
    # yabridge # Use Windows VSTs with wine
    # yabridgectl # Use Windows VSTs with wine
    # alsa-scarlett-gui
  ];

  # home.file = with config.lib.file; { TODO
  #   ".local/share/vital".source =
  #     mkOutOfStoreSymlink "${config.user.home}/life/softwareTools+myData/music.large/vital/";
  #   ".local/share/Vital".source =
  #     mkOutOfStoreSymlink "${config.user.home}/life/softwareTools+myData/music.large/vital/";
  #   ".local/share/vitalium".source =
  #     mkOutOfStoreSymlink "${config.user.home}/life/softwareTools+myData/music.large/vital/";
  #   ".local/share/Vitalium".source =
  #     mkOutOfStoreSymlink "${config.user.home}/life/softwareTools+myData/music.large/vital/";
  #   ".Surge XT".source =
  #     mkOutOfStoreSymlink "${config.user.home}/life/softwareTools+myData/music.large/SurgeXT/";
  # };
}
