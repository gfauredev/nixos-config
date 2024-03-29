# Fonts I like and use
{ pkgs, ... }: {
  home.packages = with pkgs; [
    #################### Serif Fonts ####################
    libre-baskerville # Great, stylish serif
    vollkorn # Great serif font
    # merriweather # Serif readable on low res screens
    # gelasio # Serif Georgia replacement
    # lmodern # Classic serif
    # noto-fonts-cjk-serif
    #################### Sans Fonts ####################
    fira-go # Great sans with icons
    nacelle # Helvetica equivalent
    # inter # Interesting sans font
    # carlito # Calibri equivalent
    # merriweather-sans # Sans font readable on low res
    # libre-franklin
    # noto-fonts-cjk-sans
    #################### Mono Fonts ####################
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "Iosevka"
        "IosevkaTerm"
        "IosevkaTermSlab"
        "Hack"
        # "JetBrainsMono"
        # "Noto"
        # "SourceCodePro"
        # "Ubuntu"
        # "UbuntuMono"
      ];
    })
    # fira-code # Great mono font
    # fira-code-symbols # Great icons
    # fira-code-nerdfont # Great mono with ligatures & icons
    #################### Fonts Packages ####################
    # liberation_ttf # ≃ Times New Roman, Arial, Courier New equivalents
    # nerdfonts # Big package of fonts with lots of icons
    # noto-fonts # Google well internationalized fonts
    #################### Symbols Fonts ####################
    # font-awesome # Thousands of icons
    # lmmath # Classic font with math support
    # emojione # Emojies
    # noto-fonts-emoji # Emojies
  ];
}
