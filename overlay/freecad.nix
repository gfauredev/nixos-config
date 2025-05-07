(final: prev: {
  freecad = prev.freecad-wayland.override {
    extraPkgs = pkgs:
      with pkgs; [
        openscad # Programmatic "code first" 3D CAD
        pip # Python package manager
        python3 # Scripting language for addons
        # venvShellHook # TEST if needed for Python
      ];
  };
})
