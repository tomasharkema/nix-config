{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  keys = pkgs.callPackage ../packages/authorized-keys {};
  inputValues = builtins.attrValues inputs; # .out
  drvs = builtins.map (v: v.outPath) inputValues;
  # wifi-connect = pkgs.writeShellScriptBin "wifi-connect" ''
  #   SSID="$(${lib.getExe pkgs.gum} input --placeholder SSID)"
  #   PASS="$(${lib.getExe pkgs.gum} input --password --placeholder PASS)"
  #   sudo systemctl enable --now wpa_supplicant
  #   sudo ${pkgs.wpa_supplicant}/bin/wpa_cli add_network 0
  #   sudo ${pkgs.wpa_supplicant}/bin/wpa_cli set_network 0 key_mgmt WPA-PSK
  #   sudo ${pkgs.wpa_supplicant}/bin/wpa_cli set_network 0 ssid "$SSID"
  #   sudo ${pkgs.wpa_supplicant}/bin/wpa_cli set_network 0 psk "$PASS"
  #   sudo ${pkgs.wpa_supplicant}/bin/wpa_cli enable_network 0
  #   sudo ${pkgs.wpa_supplicant}/bin/wpa_cli save_config
  # '';
in {
  config = {
    nix =
      # {
      #   package = pkgs.nixVersions.nix_2_23; # .latest;
      # }
      # //
      import ./config.nix;
    # boot.supportedFilesystems = ["bcachefs"];
    users = {
      users = {
        nixos = {
          uid = 2000;
          #gid = 2000;
        };
        tomas = {
          # shell = pkgs.zsh;
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
          initialHashedPassword = "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";
          uid = 1000;

          openssh.authorizedKeys.keyFiles = ["${keys}"];
        };
        root.openssh.authorizedKeys.keyFiles = ["${keys}"];
      };
      groups = {
        nixos.gid = 2000;
        tomas = {gid = 1000;};
      };
    };

    # programs.zsh.enable = true;

    services = {tailscale.enable = true;};

    environment.systemPackages = with pkgs; [
      nixos-install-tools
      git
      curl
      wget2
      btop
      htop
      inputs.self.packages."${pkgs.system}".nix-helpers
      # (inputs.self.packages."${pkgs.system}".installer-script.override {
      #   configurations =
      #     #builtins.trace "installer-configurations"
      #     inputs.self.nixosConfigurations;
      # })
      disko
      tailscale

      # wifi-connect
    ];
  };
}
