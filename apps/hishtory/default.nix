{ pkgs, config, ... }:
let
  # hishtory = pkgs.hishtory.override { version = "0.263"; };

  hishtory = pkgs.callPackage
    (
      { buildGoModule
      , fetchFromGitHub
      , lib
      }:

      buildGoModule
        rec {
          pname = "hishtory";
          version = "0.263";

          src = fetchFromGitHub {
            owner = "ddworken";
            repo = pname;
            rev = "v${version}";
            hash = "sha256-Pg53wYkoUKZ5mMvPVCJs8HTj5AWRUYXUArHN0f+D+Nw=";
          };

          vendorHash = "sha256-HzHLGrPXUSkyt2Dr7tLjfJrbg/EPBHkljoXIlPWIppU=";
          ldflags = [ " -X github.com/ddworken/hishtory/client/lib.Version=${version}" ];

          excludedPackages = [ "backend/server" ];

          postInstall = ''
            mkdir -p $out/share/hishtory
            cp client/lib/config.* $out/share/hishtory
          '';

          doCheck = false;

          meta = with lib; {
            description = "Your shell history: synced, queryable, and in context";
            homepage = "https://github.com/ddworken/hishtory";
            license = licenses.mit;
            maintainers = with maintainers; [ tomasharkema ];
          };
        }
    )
    { };

in
{

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
  systemd.user.services.hishtory-login =
    let
      hishtory-login-script = pkgs.writeShellScriptBin "hishtory-login-script.sh" ''
        FILE="/tmp/hishtory.key" 
        if [ -f "$FILE" ]; then
          ${pkgs.lib.getExe hishtory} init "$(cat $FILE)"
        fi
      '';
    in
    {
      Unit.Description = "hishtory-login";
      Unit.Type = "oneshot";
      Install.WantedBy = [ "multi-user.target" ];
      Service = {
        ExecStart = pkgs.lib.getExe hishtory-login-script;
      };
    };
}

