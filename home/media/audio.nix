{ pkgs, lib, ... }: {
  home.sessionVariables = let
    makePluginPath = format:
      (lib.makeSearchPath format [
        "$HOME/.nix-profile/lib"
        "/run/current-system/sw/lib"
        "/etc/profiles/per-user/$USER/lib"
      ]) + ":$HOME/.${format}";
  in {
    CLAP_PATH = lib.mkDefault (makePluginPath "clap");
    DSSI_PATH = lib.mkDefault (makePluginPath "dssi");
    LADSPA_PATH = lib.mkDefault (makePluginPath "ladspa");
    LV2_PATH = lib.mkDefault (makePluginPath "lv2");
    LXVST_PATH = lib.mkDefault (makePluginPath "lxvst");
    VST3_PATH = lib.mkDefault (makePluginPath "vst3");
    VST_PATH = lib.mkDefault (makePluginPath "vst");
  };

  home.packages = with pkgs; [
    klick # Metronome
    # Plugins hosts & Routers
    carla # VST Host & audio router
    cardinal # Plugin VCV Rack
    # ingen # Modular audio environment
    # giada # Live electronic music platform
    # helvum # PipeWire router
    # qpwgraph # PipeWire router
    # DAW & Editors
    # zrythm # Modern digital audio workstation
    ardour # Full fledged digital audio workstation
    # audacity # Simple audio editor
    # VST Collections
    distrho-ports # Collection of audio plugins, contains Vitalium
    calf # Collection of audio plugins
    bristol # Synths
    # lsp-plugins # Collection of audio plugins
    # zam-plugins # A collection of LV2/LADSPA/VST/JACK plugins
    # infamousPlugins # Collection of audio plugins
    musescore # Music writing
    # VST
    vital # PROPRIETARY Spectral warping wavetable synth
    # helm # Ancestor of Vital
    # surge-XT # Great hybrid substractive synth TODO reenable
    # surge # Great hybrid substractive synth (old version)
    # bespokesynth-with-vst2 # Software modular synth with controllers support TODO reenable
    drumgizmo # High quality drums sampler
    # Bridges & Drivers & Adapters
    # airwave # WINE-based VST bridge for Linux VST hosts
    # yabridge # Use Windows VSTs with wine TODO reenable
    # yabridgectl # Use Windows VSTs with wine TODO reenable
    # alsa-scarlett-gui
  ];
}
