{
  agenix,
  nixos-anywhere,
  nix-software-center,
  channels,
  ...
}: final: prev: {
  agenix = agenix.packages."${prev.system}".default;
  nixos-anywhere = nixos-anywhere.packages."${prev.system}".nixos-anywhere;
  nix-software-center = nix-software-center.packages."${prev.system}".nix-software-center;

  nerdfonts = prev.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "FiraCode"
      "FiraMono"
      "Terminus"
      "ComicShannsMono"
      "BigBlueTerminal"
      "NerdFontsSymbolsOnly"
      "Iosevka"
      "OpenDyslexic"
      "Noto"
    ];
  };
}
