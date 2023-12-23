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
            hash = "sha256-XDxAzMQjtCfufWnEO5NXP8Zv823a85qYhkZcEZKxIXs=";
          };

          vendorHash = "sha256-aXHqPk8iBMbe0NlsY3ZR7iozBGCAKlOOQ23FAD/5hL8=";

          ldflags = [ "-X github.com/ddworken/hishtory/client/lib.Version=${version}" ];

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
            maintainers = with maintainers; [ Enzime ];
          };
        }
    )
    { };
in
{

  age.secrets.hishtory = {
    file = ../../secrets/hishtory.age;
  };

  home.packages = [ hishtory ];

  programs.zsh = {
    initExtra = ''
      . ${hishtory}/share/hishtory/config.zsh
    '';
  };


  systemd.user.services.hishtory-login =
    {
      description = "hishtory-login";
      script = ''
        ${pkgs.lib.getExe hishtory} init "$(cat ${config.age.secrets.hishtory.path})"
      '';
      wantedBy = [ "multi-user.target" ]; # starts after login
      unitConfig.Type = "oneshot";
    };
}
