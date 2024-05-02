{
  inputs,
  pkgs,
  self,
  lib,
}: let
  disko = inputs.disko.packages."${pkgs.system}".disko;

  gum = "${lib.getExe pkgs.gum}";

  hosts = builtins.writeFile (builtins.attrNames self.nixosConfigurations);
in
  pkgs.writeShellScriptBin "installer" ''
    set -e
    echo "Login with Tailscale..."

    ${pkgs.tailscale}/bin/tailscale up --qr --accept-dns

    export HOSTNAME_INST="$(${gum} filter --placeholder Hostname < ${hosts})"

    echo "Installing $HOSTNAME_INST..."

    ${disko}/bin/disko --mode mount --flake "github:tomasharkema/nix-config#$HOSTNAME_INST" || {
      ${gum} confirm "Format disk?" && ${disko}/bin/disko --mode disko --flake "github:tomasharkema/nix-config#$HOSTNAME_INST"
    }
  ''
