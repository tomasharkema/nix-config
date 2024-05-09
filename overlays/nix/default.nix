{
  devenv,
  deploy-rs,
  attic,
  agenix,
  hydra-check,
  flake-checker,
  nixos-anywhere,
  nixos-conf-editor,
  nix-software-center,
  channels,
  # zjstatus,
  # manix,
  ...
}: final: prev: {
  attic = attic.packages."${prev.system}".default;
  devenv = devenv.packages."${prev.system}".default;
  deploy-rs = deploy-rs.packages."${prev.system}".deploy-rs;
  agenix = agenix.packages."${prev.system}".default;
  hydra-check = hydra-check.packages."${prev.system}".default;
  flake-checker = flake-checker.packages."${prev.system}".default;
  nixos-anywhere = nixos-anywhere.packages."${prev.system}".nixos-anywhere;
  nixos-conf-editor = nixos-conf-editor.packages."${prev.system}".nixos-conf-editor;
  nix-software-center = nix-software-center.packages."${prev.system}".nix-software-center;
  nixUnstable = channels.unstable.nixVersions.latest;

  # manix = manix.packages."${prev.system}".manix;

  # zjstatus = zjstatus.packages."${prev.system}".default;

  nerdfonts = channels.unstable.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "FiraCode"
      "FiraMono"
      "Terminus"
      "ComicShannsMono"
      "BigBlueTerminal"

      "OpenDyslexic"
      "Noto"
    ];
  };

  # lib =
  #   (prev.lib.maintainers or {})
  #   // {
  #     tomas = {};
  #   };
}
