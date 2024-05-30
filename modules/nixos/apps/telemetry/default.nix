{ inputs, config, lib, pkgs, ... }:
let
  # pr = builtins.trace ''
  #   ${lib.concatStrings " " (builtins.attrNames inputs)}
  # '' "derp";
  self = inputs.self;
in {
  config = lib.mkIf false {
    # system.configurationRevision = ""; #lib.mkIf (self ? rev) self.rev;
    system.activationScripts.notify.text = ''
      function notify_result {

        MESSAGE="<b>build $(hostname)</b> $(date) ${
          self.shortRev or "dirty"
        } <pre>$(${lib.getExe pkgs.nix-info} -m)</pre> <pre>$(printenv)</pre>"

        echo "$MESSAGE" | \
          ${lib.getExe pkgs.notify} -bulk -pc ${config.age.secrets.notify.path}
      }
      trap notify_result EXIT
    '';
  };
}
