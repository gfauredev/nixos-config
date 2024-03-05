{ pkgs, ... }: {
  home.packages = with pkgs; [
    appflowy # Notion alternative
    # affine # Next-gen knowledge base
  ];
}
