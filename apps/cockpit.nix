{ pkgs, ... }:
let
  reencrypt = pkgs.writeShellScriptBin "reencrypt" ''
    set -x
    cd /etc/cockpit/ws-certs.d 
    ${pkgs.tailscale}/bin/tailscale cert $(hostname).ling-lizard.ts.net || true
  '';
in
{
  services.cockpit = {
    enable = true;
    port = 9090;
    settings = { WebService = { AllowUnencrypted = true; }; };
  };
  system.activationScripts = {
    cockpitXrdpCert = "${reencrypt}/bin/reencrypt";
  };

}
