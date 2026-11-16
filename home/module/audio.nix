{
  pkgs,
  config,
  ...
}: # Audio and Music production and consumption
{
  services = {
    playerctld.enable = true;
    mpris-proxy.enable = true;
    pipewire.enable = true;
    pipewire.wireplumber.enable = config.services.pipewire.enable;
    pipewire.wireplumber.configs =
      let
        baseConfiguredPriority = 2500;
      in
      {
        "50-device-priorities" = {
          "monitor.alsa.rules" = [
            # Audio/Sink (Speakers/Headphones)
            # AfterShokz Loop 100
            {
              matches = [
                { "node.name" = "alsa_output.usb-0a12_AfterShokz_Loop_100-00.analog-stereo"; }
              ];
              actions.update-props."priority.session" = baseConfiguredPriority + 8;
            }
            # Built-in Audio
            {
              matches = [
                { "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo"; }
              ];
              actions.update-props."priority.session" = baseConfiguredPriority + 4;
            }
            # Generic USB Audio
            {
              matches = [
                { "node.name" = "alsa_output.usb-Generic_USB_Audio_201604140001-00.analog-stereo"; }
              ];
              actions.update-props."priority.session" = baseConfiguredPriority + 2;
            }
            # Audio/Source (Microphones)
            # AfterShokz Loop 100
            {
              matches = [
                { "node.name" = "alsa_input.usb-0a12_AfterShokz_Loop_100-00.mono-fallback"; }
              ];
              actions.update-props."priority.session" = baseConfiguredPriority + 8;
            }
            # Creative Live! Cam Sync 1080p V2 Mic
            {
              matches = [
                {
                  "node.name" =
                    "alsa_input.usb-Creative_Technology_Ltd._Creative_Live__Cam_Sync_1080p_V2_Creative_Live__Cam_Sync_1080p_V2_Audio-02.analog-stereo";
                }
              ];
              actions.update-props."priority.session" = baseConfiguredPriority + 4;
            }
            # Built-in Audio Mic
            {
              matches = [
                { "node.name" = "alsa_input.pci-0000_00_1f.3.analog-stereo"; }
              ];
              actions.update-props."priority.session" = baseConfiguredPriority + 2;
            }
            # Generic USB Audio Mic
            {
              matches = [
                { "node.name" = "alsa_input.usb-Generic_USB_Audio_201604140001-00.analog-stereo"; }
              ];
              actions.update-props."priority.session" = baseConfiguredPriority + 1;
            }
          ];
          # Video/Source (Cameras)
          "monitor.v4l2.rules" = [
            # Creative Live! Cam Sync 1080p V2
            {
              matches = [
                { "node.nick" = "Creative Live! Cam Sync 1080p V2"; }
              ];
              actions.update-props."priority.session" = baseConfiguredPriority + 8;
            }
            # Laptop Camera
            {
              matches = [
                { "node.nick" = "Laptop Camera"; }
              ];
              actions.update-props."priority.session" = baseConfiguredPriority + 4;
            }
          ];
        };
        # Prevent WirePlumber's saved user selections from overriding those
        "51-strict-priority-selection" = {
          "wireplumber.settings" = {
            "node.restore-default-targets" = false;
          };
        };
      };
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
    pipewire.jack # PipeWire JACK CLI tools
    wiremix # TUI mixer
    qpwgraph # PipeWire router
    pwvucontrol # GUI PipeWire volume control
    coppwr # TEST
    ardour # Full fledged digital audio workstation
    # bespokesynth # Software modular synth, controllers support
    carla # VST Host & audio router
    cardinal # Standalone and VST modular synthesizer
    # giada # Live electronic music platform
    glicol-cli # Music live coding
    helio-workstation # Sequencer / DAW
    # crosspipe # Audio patchbay
    # ingen # Modular audio environment
    # ossia-score # Interactive sequencer
    # patchage # JACK router
    # supercollider # Audio synthesis and algorithmic composition
    # vcv-rack # Standalone modular synthesizer
    # vmpk # Virtual keyboard
    knobkraft-orm # MIDI SysEx librarian
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

  # home.file = with config.lib.file; {
  #   ".local/share/vital".source = mkOutOfStoreSymlink "${config.user.home}/…/vital/";
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
