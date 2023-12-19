{ pkgs, ... }: {
  home.packages = with pkgs; [
    libsForQt5.kdenlive # simple video editor (works on nvidia)
    glaxnimate # video editing library used by kdenlive
    # shotcut # video editor
    # flowblade # non linear video editor
    # olive-editor # non linear video editor
    # losslesscut-bin # Basic lossless video edditing using ffmpeg

    obs-studio
    obs-studio-plugins.wlrobs
    # obs-wlrobs

    # davinci-resolve # PROPRIETARY video editor
  ];
}
