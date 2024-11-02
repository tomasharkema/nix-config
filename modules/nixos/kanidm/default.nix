{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
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

    environment = {
      systemPackages = with pkgs; [
        kanidm-provision
      ];

      etc."ssh/authorized_keys_command" = {
        mode = "0755";
        text = ''
          #!/bin/sh
          exec ${pkgs.kanidm}/bin/kanidm_ssh_authorizedkeys "$@"
        '';
      };
    };

    services = {
      openssh = {
        authorizedKeysCommand = "/etc/ssh/authorized_keys_command";
        authorizedKeysCommandUser = "nobody";
      };

      sssd.enable = false;

      kanidm = {
        enableClient = true;
        enablePam = true;

        package = pkgs.kanidm.overrideAttrs (old: rec {
          version = "1.4.0";
          src = pkgs.fetchFromGitHub {
            owner = old.pname;
            repo = old.pname;
            rev = "refs/tags/v${version}";
            hash = "sha256-hRYHr4r3+LRiaZoJgs3MA5YtDEoKyeg/ohPAIw3OMyo=";
          };

          cargoDeps = old.cargoDeps.overrideAttrs (_: {
            inherit src; # You need to pass "src" here again,
            # otherwise the old "src" will be used.
            outputHash = "sha256-DfTalKTOiReQCreAzbkSjbhMSW5cdOGGg04i/QKPonE=";
          });
        });

        clientSettings = {
          uri = "https://idm.harke.ma";
        };

        unixSettings = {
          pam_allowed_login_groups = ["allusers"];
          home_attr = "name";
          home_alias = "name";
          allow_local_account_override = ["tomas"];
          selinux = false;
          default_shell = "${pkgs.zsh}/bin/zsh";
          uid_attr_map = "name";
          gid_attr_map = "name";
        };
      };
    };
  };
}
