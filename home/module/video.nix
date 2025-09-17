{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg # media conversion
    yt-dlp # download videos from YouTube or other video site
    # mplayer # Video viewer TEST me
    # vlc # Video viewer TEST me
    # losslesscut-bin # Basic lossless video edditing using ffmpeg
    # libsForQt5.kdenlive # simple video editor (works on nvidia) FIXME
    # glaxnimate # video editing library used by kdenlive
    # shotcut # video editor
    # flowblade # non linear video editor
    # olive-editor # non linear video editor
    # obs-wlrobs
    obs-studio-plugins.wlrobs # OBS for Wayland
    obs-studio # Screen recorder and streaming
  ];
}
