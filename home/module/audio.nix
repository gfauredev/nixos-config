{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: # Audio production and edition
{
  home.sessionVariables =
    let
      makePluginPath =
        format:
        (lib.makeSearchPath format [
          "$HOME/.nix-profile/lib"
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
        ])
        + ":$HOME/.${format}";
    in
    {
      CLAP_PATH = lib.mkDefault (makePluginPath "clap");
      DSSI_PATH = lib.mkDefault (makePluginPath "dssi");
      LADSPA_PATH = lib.mkDefault (makePluginPath "ladspa");
      LV2_PATH = lib.mkDefault (makePluginPath "lv2");
      LXVST_PATH = lib.mkDefault (makePluginPath "lxvst");
      VST3_PATH = lib.mkDefault (makePluginPath "vst3");
      VST_PATH = lib.mkDefault (makePluginPath "vst");
    };

  home.packages = with pkgs; [
    ardour # Full fledged digital audio workstation
    carla # VST Host & audio router
    pkgs-unstable.bespokesynth-with-vst2 # Software modular synth, controllers support
    cardinal # Standalone and VST modular synthesizer
    # vcv-rack # Standalone modular synthesizer
    # ingen # Modular audio environment
    # giada # Live electronic music platform
    # helvum # PipeWire router
    # qpwgraph # PipeWire router
    # DAW & Editors
    # zrythm # Modern digital audio workstation
    # audacity # Simple audio editor
    neothesia # MIDI piano roll player
    musescore # Music writing
    # VST
    distrho-ports # Collection of audio plugins, contains Vitalium
    surge-XT # Great hybrid substractive synth
    calf # Collection of audio plugins
    bristol # Synths
    # lsp-plugins # Collection of audio plugins
    # zam-plugins # A collection of LV2/LADSPA/VST/JACK plugins
    # infamousPlugins # Collection of audio plugins
    drumgizmo # High quality drums sampler
    # vital # PROPRIETARY Spectral warping wavetable synth
    # Bridges & Drivers & Adapters
    # airwave # WINE-based VST bridge for Linux VST hosts
    # yabridge # Use Windows VSTs with wine
    # yabridgectl # Use Windows VSTs with wine
    # alsa-scarlett-gui
  ];
}
