{ pkgs, lib, ... }:
with lib; {
  config = mkIf false {
    # age.secrets.hishtory-home = {
    #   file = ../../secrets/hishtory.age;
    #   mode = "770";
    # };

    home.packages = [ hishtory ];

    programs.zsh = {
      initExtra = ''
        . ${hishtory}/share/hishtory/config.zsh
      '';
    };

    # "${config.age.secrets.hishtory-home.path}"
    systemd.user.services.hishtory-login = let
      hishtory-login-script =
        pkgs.writeShellScriptBin "hishtory-login-script.sh" ''
          FILE="/tmp/hishtory.key"
          if [ -f "$FILE" ]; then
            ${pkgs.lib.getExe hishtory} init "$(cat $FILE)"
          fi
        '';
    in {
      Unit.Description = "hishtory-login";
      Unit.Type = "oneshot";
      Install.WantedBy = [ "multi-user.target" ];
      Service = { ExecStart = pkgs.lib.getExe hishtory-login-script; };
    };
  };
}
