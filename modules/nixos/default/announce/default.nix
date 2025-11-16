{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    system.activationScripts.announce = let
      ntfy = "${pkgs.ntfy-sh}/bin/ntfy";
      cat = "${pkgs.coreutils}/bin/cat";
    in ''
      (
        GENERATION="$(readlink /nix/var/nix/profiles/system)"
        GENPATH="$(readlink -f /nix/var/nix/profiles/system)"

        ${ntfy} publish --title "$HOSTNAME Activate $GENERATION" "$(${cat} ${config.age.secrets.ntfy.path})" "$GENERATION $GENPATH" || true
      )
    '';
  };
}
