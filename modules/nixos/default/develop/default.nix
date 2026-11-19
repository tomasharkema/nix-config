{pkgs, ...}: let
  # pico-sdk = pkgs.pico-sdk.overrideAttrs (o: rec {
  # pname = "pico-sdk";
  # version = "2.1.1";
  # src = pkgs.fetchFromGitHub {
  #   owner = "raspberrypi";
  #   repo = "pico-sdk";
  #   rev = version;
  #   hash = "sha256-8ru1uGjs11S2yQ+aRAvzU53K8mreZ+CC3H+ijfctuqg="; # "sha256-TiqpgwVNhPlONqJJo/8AQuIsjHiYT+II4n0b0/D76aw=";
  #   fetchSubmodules = true;
  # };
  # });
in {
  config = {
    environment.systemPackages = with pkgs; [
      # keep-sorted start
      arduino-cli
      arduino-language-server
      arduino-ota
      bazel
      cmakeCurses
      delve
      elf2uf2-rs
      flip-link
      gcc-arm-embedded
      gdlv
      gnumake
      go
      go-outline
      godef
      golangci-lint
      golint
      gopkgs
      gopls
      gotools
      meson
      picotool
      probe-rs-tools
      rustup
      # keep-sorted end
    ];

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", MODE="0666"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0005", SYMLINK+="pico"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000f", SYMLINK+="pico"
    '';
  };
}
