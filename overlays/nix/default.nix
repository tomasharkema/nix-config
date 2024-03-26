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
  ...
}: final: prev: {
  devenv = devenv.packages."${prev.system}".default;
  deploy-rs = deploy-rs.packages."${prev.system}".deploy-rs;
  attic = attic.packages."${prev.system}".default;
  agenix = agenix.packages."${prev.system}".default;
  hydra-check = hydra-check.packages."${prev.system}".default;
  flake-checker = flake-checker.packages."${prev.system}".default;
  nixos-anywhere = nixos-anywhere.packages.${prev.system}.nixos-anywhere;
  nixos-conf-editor = nixos-conf-editor.packages.${prev.system}.nixos-conf-editor;
  nix-software-center = nix-software-center.packages.${prev.system}.nix-software-center;
  nixUnstable = channels.unstable.nixVersions.nix_2_20;
}
