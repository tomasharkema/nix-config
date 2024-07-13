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
  drvs = builtins.map (v: v.outPath) inputValues;

  wifi-connect = pkgs.writeShellScriptBin "wifi-connect" ''
    SSID="$(${getExe gum} input --placeholder SSID)"
    PASS="$(${getExe gum} input --password --placeholder PASS)"

    sudo systemctl enable --now wpa_supplicant

    wpa_cli add_network 0
    wpa_cli set_network 0 key_mgmt WPA-PSK
    wpa_cli set_network 0 ssid "$SSID"
    wpa_cli set_network 0 psk "$PASS"
    wpa_cli enable_network 0
    wpa_cli save_config
  '';
in {
  config = {
    # nix.extraOptions = "experimental-features = nix-command flakes c";
    # isbinaryCaches
    # environment.etc."current-nixos".source = ./.;
    nix =
      {
        package = pkgs.nixVersions.latest;
      }
      // import ./config.nix;
    boot.supportedFilesystems = ["bcachefs"];
    users = {
      users = {
        nixos = {uid = 2000;};
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
          hashedPassword = "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";
          uid = 1000;
          openssh.authorizedKeys.keyFiles = ["${keys}"];
        };
        root.openssh.authorizedKeys.keyFiles = ["${keys}"];
      };
      groups.tomas = {};
    };

    programs.zsh.enable = true;

    services = {tailscale.enable = true;};

    environment.systemPackages = with pkgs; [
      git
      curl
      wget
      atop
      btop
      htop
      (inputs.self.packages."${pkgs.system}".installer-script.override {
        configurations = inputs.self.nixosConfigurations;
      })
      disko
      tailscale

      wifi-connect
    ];
  };
}
