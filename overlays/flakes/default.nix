{
  channels,
  disko,
  self,
  inputs,
  lib,
  ...
}: final: prev: let
  system' = final.stdenv.hostPlatform.system;
in {
  librepods = inputs.librepods.packages.${system'}.default;
  nox = inputs.nox.packages.${system'}.default;
  nix-alien = inputs.nix-alien.packages.${system'}.default;
  # compose2nix = inputs.compose2nix.packages."${system'}".default;
  piratebay = inputs.piratebay.packages."${system'}".default;
  # wezterm = inputs.wezterm.packages."${system'}".default;
  # nixd = inputs.nixd.packages."${system'}".default;
}
