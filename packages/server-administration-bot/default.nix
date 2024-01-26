{
  pkgs,
  inputs,
  config,
  lib,
  # self,
  ...
}: {
  imports = [
    inputs.dream2nix.modules.dream2nix.mkDerivation
  ];

  name = "server-administration-bot";
  version = "2.12";

  deps = {nixpkgs, ...}: {
    inherit
      (nixpkgs)
      stdenv
      ;
  };

  mkDerivation = {
    src = pkgs.fetchFromGitHub {
      owner = "gregdan3";
      repo = "server-administration-bot";
      rev = "master";
      sha256 = "sha256-H8yhEMppfkt0l9bn3w9BkwniQiK9FFNKhbXMaYczTzw="; #"sha256-cHSKe9Al+ezW1v7rqLpj+OiRoa9V9I42bW1ueEk6uoQ=";
    };
  };
}
