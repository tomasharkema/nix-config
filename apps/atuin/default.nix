{ config
, pkgs
, ...
}:
let
  atuin-login = pkgs.writeShellScriptBin "atuin-login" ''
    ${pkgs.bash}/bin/bash ${ config.age.secrets."atuin".path}
  '';
in
{

  systemd.user.services.atuin-login =
    {
      Unit.Description = "atuin-login";
      Install.WantedBy = [ "multi-user.target" ];
      Service = {
        ExecStart = ''${atuin-login}'';
        Type = "oneshot";
      };
    };

  # home.packages = [ atuin-login ];
  age.secrets.atuin = {
    file = ../../secrets/atuin.age;
  };
  # age.secrets.atuin-session = {
  #   file = ../../secrets/atuin-session.age;
  #   # owner = "tomas";
  #   # group = "tomas";
  #   symlink = false;
  #   path = "$HOME/.local/share/atuin/session";
  #   mode = "0644";
  # };
  # age.secrets.atuin-hostid = {
  #   file = ../../secrets/atuin-hostid.age;
  #   # owner = "tomas";
  #   # group = "tomas";
  #   symlink = false;
  #   path = "$HOME/.local/share/atuin/host_id";
  #   mode = "0644";
  # };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    settings =
      {
        # key_path = "/tmp/atuin-key.key"; #config_key;
        # session_path = "/tmp/atuin-session.key"; #config_session;
        sync_frequency = "15m";
        sync_address = "https://atuin.harke.ma";
        enter_accept = false;
        workspaces = true;
      };
  };
}
