# Fonts I like and use
{ pkgs, ... }: {
  packages = with pkgs; [
    #################### Serif Fonts ####################
    libre-baskerville # Great, stylish serif
    vollkorn # Great serif font
    # merriweather # Serif readable on low res screens
    # gelasio # Serif Georgia replacement
    # lmodern # Classic serif
    # noto-fonts-cjk-serif
    #################### Sans Fonts ####################
    fira-go # Great sans with icons
    nacelle # Helvetica replacement
    # inter # Interesting sans font
    # carlito # Calibri replacement
    # merriweather-sans # Sans font readable on low res
    # libre-franklin
    # noto-fonts-cjk-sans
    #################### Mono Fonts ####################
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    # fira-code # Great mono with ligatures & icons
    #################### Fonts Packages ####################
    # liberation_ttf # Times New Roman, Arial, Courier New
    # nerdfonts # Mono fonts with lots of icons
    # noto-fonts
    #################### Symbols Fonts ####################
    lmmath # Classic font with math support
    # emojione # Emoticons
    # font-awesome # A lot of icons
    # noto-fonts-emoji # Emojies
  ];
}
