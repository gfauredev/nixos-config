{ pkgs, stablepkgs, ... }: {
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
    # reaper # PROPRIETARY digital audio workstation
    # audacity # Simple audio editor
    # VST Collections
    stablepkgs.distrho # Collection of audio plugins, contains Vitalium
    calf # Collection of audio plugins
    bristol # Synths
    # lsp-plugins # Collection of audio plugins
    # zam-plugins # A collection of LV2/LADSPA/VST/JACK plugins
    # infamousPlugins # Collection of audio plugins
    # VST
    vital # PROPRIETARY Spectral warping wavetable synth
    # helm # Ancestor of Vital
    surge-XT # Great hybrid substractive synth
    # surge # Great hybrid substractive synth (old version)
    bespokesynth-with-vst2 # Software modular synth with controllers support
    drumgizmo # High quality drums sampler
    # Bridges & Drivers & Adapters
    # airwave # WINE-based VST bridge for Linux VST hosts
    # yabridge # Use Windows VSTs with wine TODO reenable
    # yabridgectl # Use Windows VSTs with wine TODO reenable
    # alsa-scarlett-gui
  ];
}
