{ pkgs, ... }: {
  home.packages = with pkgs; [
    #################### Serif ####################
    libre-baskerville # Great, stylish serif
    vollkorn # Great serif font
    # merriweather # Serif readable on low res screens
    # gelasio # Serif Georgia replacement
    # lmodern # Classic serif
    # noto-fonts-cjk-serif
    #################### Sans ####################
    fira-go # Great sans with icons
    nacelle # Helvetica equivalent
    inter # Interesting sans font
    carlito # Calibri equivalent
    # merriweather-sans # Sans font readable on low res
    # libre-franklin
    noto-fonts-cjk-sans # Chinese, Japanese, Korean sans
    #################### Mono ####################
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "Iosevka"
        # "IosevkaTerm"
        # "IosevkaTermSlab"
        "Hack"
        # "Noto"
        # "JetBrainsMono"
        # "SourceCodePro"
        # "Ubuntu"
        # "UbuntuMono"
      ];
    })
    # fira-code # Great mono font
    # fira-code-symbols # Great icons
    #################### Packages ####################
    # nerdfonts # Big package of fonts with lots of icons
    liberation_ttf # ≃ Times New Roman, Arial, Courier New equivalents
    # noto-fonts # Google well internationalized fonts
    #################### Symbols ####################
    noto-fonts-emoji # Emojies
    # emojione # Emojies
    # lmmath # Classic font with math support
    # font-awesome # Thousands of icons
  ];
}
