{ pkgs, lib, inputs, config, ... }:
with lib;
let
  disko = inputs.disko.packages."${pkgs.system}".disko;
  keys = pkgs.callPackage ./packages/authorized-keys { };
  inputValues = builtins.attrValues inputs; # .out
  drvs = builtins.map (v: v.outPath) inputValues;
in {
  config = {
    # nix.extraOptions = "experimental-features = nix-command flakes c";
    # isbinaryCaches
    # environment.etc."current-nixos".source = ./.;
    nix = { package = pkgs.nixVersions.nix_2_21; } // import ./config.nix;

    users = {
      users = {
        nixos = { uid = 2000; };
        tomas = {
          shell = pkgs.zsh;
          isNormalUser = true;
          description = "tomas";
          group = "tomas";
          extraGroups = [
            "networkmanager"
            "wheel"
            "rslsync"
            "users"
            "fuse"
            "disk"
            "plugdev"
            "dailout"
          ];
          hashedPassword =
            "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";
          uid = 1000;
          openssh.authorizedKeys.keyFiles = [ "${keys}" ];
        };
        root.openssh.authorizedKeys.keyFiles = [ "${keys}" ];
      };
      groups.tomas = { };
    };

    programs.zsh.enable = true;

    services = { tailscale.enable = true; };

    environment.systemPackages = with pkgs; [
      git
      curl
      wget
      btop
      htop
      (inputs.self.packages."${pkgs.system}".installer-script.override {
        configurations = inputs.self.nixosConfigurations;
      })
      disko
      tailscale
    ];
  };
}
