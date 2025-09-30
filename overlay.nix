# ./overlays/default.nix
{
  ...
}:

{
  nixpkgs.overlays = [
    # `self` and `super` to express the inheritance relationship
    (self: super: {
      bambu-studio = super.appimageTools.wrapType2 rec {
        name = "BambuStudio";
        pname = "bambu-studio";
        version = "02.02.02.56";
        ubuntu_version = "24.04_PR-8184";
        src = super.fetchurl {
          url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_ubuntu-${ubuntu_version}.AppImage";
          sha256 = "sha256-ziipEMz58lG/+uxubCd53c6BjJ9W3doJ9/Z8VJp+Za4=";
        };
        profile = ''
          export SSL_CERT_FILE="${super.cacert}/etc/ssl/certs/ca-bundle.crt"
          export GIO_MODULE_DIR="${super.glib-networking}/lib/gio/modules/"
        '';
        extraPkgs =
          pkgs: with pkgs; [
            cacert
            glib
            glib-networking
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            webkitgtk_4_1
          ];
      };
    })
    # (self: super: { _7zz = super._7zz.override { useUasm = true; }; })

    # `final` and `prev` to express relationship between new and the old
    # (final: prev: { freecad = prev.freecad.override { }; })
  ];
}
