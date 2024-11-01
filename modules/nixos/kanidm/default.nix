{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf true {

    environment.systemPackages = with pkgs; [
      kanidm-provision
    ];

    system.nssDatabases = {
      group = lib.mkForce [
        "kanidm"
        "compat"
        "systemd"
      ];
      passwd = lib.mkForce [
        "kanidm"
        "compat"
        "systemd"
      ];
    };

    services = {
      sssd.enable = false;

      kanidm = {
        enableClient = true;
        enablePam = true;

        clientSettings = {
          uri = "https://idm.harke.ma";
        };

        unixSettings = {
          pam_allowed_login_groups = [ "allusers" ];
          allow_local_account_override = [ "tomas" ];
          selinux = false;
          default_shell = "${pkgs.zsh}/bin/zsh";
        };
      };
    };
  };
}
