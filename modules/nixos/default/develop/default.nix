{
  lib,
  pkgs,
  config,
  ...
}: let
  pico-sdk = pkgs.pico-sdk.overrideAttrs (o: rec {
    # pname = "pico-sdk";
    # version = "2.1.1";
    # src = pkgs.fetchFromGitHub {
    #   owner = "raspberrypi";
    #   repo = "pico-sdk";
    #   rev = version;
    #   hash = "sha256-8ru1uGjs11S2yQ+aRAvzU53K8mreZ+CC3H+ijfctuqg="; # "sha256-TiqpgwVNhPlONqJJo/8AQuIsjHiYT+II4n0b0/D76aw=";
    #   fetchSubmodules = true;
    # };
  });
in {
  config = {
    environment.systemPackages = with pkgs; [
      arduino
      arduino-cli
      arduinoOTA
      elf2uf2-rs
      probe-rs-tools
      rustup
      probe-rs
      flip-link
      arduino-language-server

      picotool
      cmakeCurses
      gcc-arm-embedded
      gnumake

      arduinoOTA
      arduino-ide
      arduino-language-server

      picotool
      cmakeCurses
      gcc-arm-embedded
      gnumake

      go
      go-outline
      gdlv
      delve
      godef
      golint
      gopkgs
      gopls
      gotools
      golangci-lint
    ];

    services.udev.packages = with pkgs; [picotool];
  };
}
