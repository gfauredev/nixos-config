{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # losslesscut-bin # Basic lossless video edditing using ffmpeg

    glaxnimate # video editing library used by kdenlive
    libsForQt5.kdenlive # simple video editor (works on nvidia)
    # shotcut # video editor
    # flowblade # non linear video editor
    # olive-editor # non linear video editor

    # obs-wlrobs
    obs-studio-plugins.wlrobs # OBS for Wayland
    obs-studio # Screen recorder and streaming
  ];
}
