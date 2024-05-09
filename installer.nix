{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with lib; let
  disko = inputs.disko.packages."${pkgs.system}".disko;
  keys = pkgs.callPackage ./packages/authorized-keys {};
  inputValues = builtins.attrValues inputs; # .out
  drvs =
    builtins.map (v: v.outPath)
    inputValues;
in {
  config = {
    # nix.extraOptions = "experimental-features = nix-command flakes c";
    isoImage = {
      squashfsCompression = "gzip -Xcompression-level 1";
      # includeSystemBuildDependencies = true;
      storeContents = drvs;
    };

    nix =
      {
        package = pkgs.nix;
      }
      // import ./config.nix;

    users = {
      users.tomas = {
        shell = pkgs.zsh;
        isNormalUser = true;
        description = "tomas";
        group = "tomas";
        extraGroups = ["networkmanager" "wheel" "rslsync" "users" "fuse" "disk" "plugdev" "dailout"];
        hashedPassword = "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";

        openssh.authorizedKeys.keyFiles = ["${keys}"];
      };
      groups.tomas = {};
    };

    programs.zsh.enable = true;

    services = {
      tailscale.enable = true;
    };

    environment.systemPackages = with pkgs; [
      git
      curl
      wget
      btop
      htop
      atop
      (inputs.self.packages."${pkgs.system}".installer-script.override {
        configurations = inputs.self.nixosConfigurations;
      })
      disko
      tailscale
    ];
  };
}
