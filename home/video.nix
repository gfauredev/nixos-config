{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # TODO use specific options when possible
    # TEST which is better
    blender # 3D, animation & video editor
    # losslesscut-bin # Basic lossless video edditing using ffmpeg
    # libsForQt5.kdenlive # video editor
    # shotcut # video editor
    # davinci-resolve # PROPRIETARY video editor
    # glaxnimate # video editing library
    # flowblade # non linear video editor
    olive-editor # non linear video editor
    # natron # non linear video editor

    # obs-studio
    # obs-studio-plugins.wlrobs
    # obs-wlrobs
  ];
}
