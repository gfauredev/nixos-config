{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Tools
    klick # Metronome
    giada # Live electronic music platform
    carla # VST Host & audio router
    ingen # Modular audio environment
    # helvum # PipeWire router
    # qpwgraph # PipeWire router
    # DAW & Editors
    # zrythm # Modern digital audio workstation
    ardour # Full fledged digital audio workstation
    # reaper # PROPRIETARY digital audio workstation
    # audacity # Simple audio editor
    # VST
    distrho # Collection of audio plugins, contains Vitalium
    # helm # Ancestor of Vital
    # lsp-plugins # Collection of audio plugins
    calf # Collection of audio plugins
    # infamousPlugins # Collection of audio plugins
    # surge-XT # Great hybrid substractive synth
    # surge # Great hybrid substractive synth (old version)
    drumgizmo # High quality drums sampler
    # Misc
    yabridge # Use Windows VSTs with wine
    yabridgectl # Use Windows VSTs with wine
    # Drivers & Adapters
    # alsa-scarlett-gui
  ];
}
