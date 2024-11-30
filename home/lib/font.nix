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
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.iosevka
    nerd-fonts.hack
    #################### Packages ####################
    liberation_ttf # ≃ Times New Roman, Arial, Courier New equivalents
    # noto-fonts # Google well internationalized fonts
    #################### Symbols ####################
    noto-fonts-emoji # Emojies
    # fira-code-symbols # Great icons
    # emojione # Emojies
    # lmmath # Classic font with math support
    # font-awesome # Thousands of icons
  ];
}
