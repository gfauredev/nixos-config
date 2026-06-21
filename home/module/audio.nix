{
  pkgs,
  pkgs-unstable,
  config,
  ...
}: # Audio and Music production and consumption
{
  services = {
    playerctld.enable = true;
    mpris-proxy.enable = true;
  };

  home.sessionVariables = {
    CLAP_PATH = "${config.user.home}/.nix-profile/lib/clap";
    DSSI_PATH = "${config.user.home}/.nix-profile/lib/dssi";
    LADSPA_PATH = "${config.user.home}/.nix-profile/lib/ladspa";
    LV2_PATH = "${config.user.home}/.nix-profile/lib/lv2";
    LXVST_PATH = "${config.user.home}/.nix-profile/lib/lxvst";
    VST3_PATH = "${config.user.home}/.nix-profile/lib/vst3";
    VST_PATH = "${config.user.home}/.nix-profile/lib/vst";
  };

  home.packages = with pkgs; [
    ardour # Full fledged digital audio workstation
    pipewire.jack # PipeWire JACK CLI tools
    pkgs-unstable.bespokesynth # Software modular synth, controllers support
    carla # VST Host & audio router
    cardinal # Standalone and VST modular synthesizer
    # giada # Live electronic music platform
    glicol-cli # Music live coding
    helio-workstation # Sequencer / DAW
    # crosspipe # Audio patchbay
    hyprpwcenter # Hypr’s PipeWire control center TEST me
    pwvucontrol # PipeWire volume control TEST me
    # ingen # Modular audio environment
    # ossia-score # Interactive sequencer
    # patchage # JACK router
    # qpwgraph # PipeWire router
    # supercollider # Audio synthesis and algorithmic composition
    # vcv-rack # Standalone modular synthesizer
    # vmpk # Virtual keyboard
    knobkraft-orm # MIDI SysEx librarian
    # TODO Package https://github.com/eclab/edisyn
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
    surge-xt # Great hybrid substractive synth
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

  xdg.desktopEntries.carla = {
    name = "Carla";
    genericName = "Audio Plugin Host";
    comment = "Carla audio plugin host (PipeWire JACK wrapper)";
    # genericName[fr] = "Hôte de greffon Carla";
    # comment[fr] = "Hôte de greffon audio";
    exec = "${pkgs.pipewire.jack}/bin/pw-jack carla %u"; # FIX Find PW’s JACK
    icon = "carla";
    terminal = false;
    type = "Application";
    categories = [
      "Audio"
      "AudioVideo"
      "X-AudioEditing"
    ];
    mimeType = [ "application/x-carla-project" ];
  };
}
