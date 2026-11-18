{ pkgs, ... }:
{
  programs = {
    obs-studio.enable = true;
    obs-studio.plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      waveform
      # wlrobs
      # advanced-scene-switcher
      # obs-text-pthread
      # obs-markdown
      # obs-source-record
      # obs-replay-source
      # obs-command-source
      # obs-composite-blur
      # obs-vintage-filter
      # obs-scale-to-sound
      # obs-source-switcher
      # obs-plugin-countdown
      # obs-media-controls
      # obs-noise
      # obs-color-monitor
    ];
  };

  home.packages = with pkgs; [
    ffmpeg # media conversion
    yt-dlp # download videos from YouTube or other video site
    # mplayer # Video viewer
    # vlc # Video viewer
    # losslesscut-bin # Basic lossless video edditing using ffmpeg
    # libsForQt5.kdenlive # simple video editor (works on nvidia)
    # glaxnimate # video editing library used by kdenlive
    # shotcut # video editor
    # flowblade # non linear video editor
    # olive-editor # non linear video editor
  ];
}
