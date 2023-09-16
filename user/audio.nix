{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    yabridge # use VSTs with wine
    yabridgectl # use VSTs with wine
    # TODO use specific options when possible
    klick # Metronome
    qpwgraph # PipeWire flux visualisation and control
    ardour # Full fledged digital audio workstation
    distrho # Repository of audio plugins
    easyeffects # Realtime pipewire effects
    drumgizmo # High quality drums sampler
    # audacity # Simple audio editor
    # alsa-scarlett-gui
    # geonkick
    # surge-XT
    # lsp-plugins
    # fluidsynth
    # linuxsampler
    # qsampler
    # helm
    # drumkv1
    # samplv1
    # surge
  ];
}
