{ inputs, lib, config, pkgs, ... }: {
  # TODO work with musnix & realtime
  home.packages = with pkgs; [
    # TODO use specific options when possible
    playerctl # MPRIS media players control
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
