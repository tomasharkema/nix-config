{
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  disko = inputs.disko.packages."${pkgs.system}".disko;
  keys = pkgs.callPackage ./packages/authorized-keys {};

  gum = "${pkgs.gum}/bin/gum";

  installerScript = pkgs.writeShellScriptBin "installer-script" ''
    set -e
    echo "Login with Tailscale..."

    ${pkgs.tailscale}/bin/tailscale up --qr --accept-dns

    HOSTNAME_INST="$(${gum} filter --placeholder \"Hostname\")"

    echo "Installing $HOSTNAME_INST..."

    ${disko}/bin/disko --mode mount --flake 'github:tomasharkema/nix-config#$HOSTNAME_INST' || {
      ${gum} confirm "Format disk?" && ${disko}/bin/disko --mode disko --flake 'github:tomasharkema/nix-config#$HOSTNAME_INST'
    }
  '';
  installer = pkgs.writeShellScriptBin "installer" ''
    sudo ${installerScript}/bin/installer-script
  '';
in {
  config = {
    # nix.extraOptions = "experimental-features = nix-command flakes c";

    nix = {
      package = pkgs.nix;
      settings.experimental-features = ["nix-command" "flakes"];
    };
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
      installer
      disko
      tailscale
    ];
  };
}
