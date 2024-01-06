{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}: let
  reencrypt = pkgs.writeShellScriptBin "reencrypt" ''
    set -x
    cd /etc/cockpit/ws-certs.d
    ${pkgs.tailscale}/bin/tailscale cert $(hostname).ling-lizard.ts.net || true
  '';
in {
  config = {
    services.cockpit = {
      enable = true;
      port = 9090;
      settings = {WebService = {AllowUnencrypted = false;};};
    };
    system.activationScripts = {
      cockpitXrdpCert = "${reencrypt}/bin/reencrypt";
    };
    environment.etc = {
      "pam.d/cockpit".text = lib.mkForce ''
        # Account management.
        account required pam_unix.so # unix (order 10900)

        # Authentication management.
        auth sufficient pam_unix.so likeauth try_first_pass # unix (order 11600)
        auth required pam_deny.so # deny (order 12400)

        # Password management.
        password sufficient pam_unix.so nullok yescrypt # unix (order 10200)

        # Session management.
        session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
        session required pam_unix.so # unix (order 10200)
        session required /nix/store/nhbab2wcqcz5sds4c2ki89lyqsfpiscs-linux-pam-1.5.2/lib/security/pam_limits.so conf=/nix/store/b2c1pdvnmqaib1gpkz6awjhjy69i1jza-limits.conf # limits (order 12200)

        auth required pam_google_authenticator.so nullok
      '';
    };
  };
}
