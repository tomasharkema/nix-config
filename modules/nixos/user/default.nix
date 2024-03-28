{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  githubKeys = lib.splitString "\n" (builtins.readFile (pkgs.fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-YJLSHQN5TotsCLHRX35VzemFZ1kYMAfJkfH89EZyptU=";
  }));
  keys =
    [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRzOjHZdqy0NfDPi9+9onjJKYQA23+0v+a0nnQ0VgvMCEPyHzM3UQwrq6RNNXt/8OQ1U89cFz726mL/nNljeSvfFodmSukk5h7D+5pQwTLTVQprmjumHJU8S6JgW8d2RYbvUlPxOed4kPkBD414qQoi+nQTynDPPKnIzFWuLEgDmSsS0KMb+l6Y0AdC9X+i3lMT1cK8EqsqIDjGvnFaTyXisr/yjdx3nR/1X9qD1PXQmbnw0dRa7EJZ5kQ9J8Zllju3qe98LibD8Kgsu0QeXYf3Hwm18JWq5uJdKobeyditg2deIfKwXk8fgk8S7lfZwaR+WLDhh3cU+Fo43BRgl9FJx04GjXjqMs9OOO5xVsLF+ch+EdMPwO2ag7lYxXfBQNwkNDOk6PSoaHwSXrnOMQIgo2zUh4W689pL8AbMGnvLvQSo106EtKB1WTJF1ZjvSBpYNeN9TUxZ3RrnbDsJDT/gQ6NeUTFa5/wliiHjWQ6N4p8m87kIlGQRzjEg70YfJjPQ/6KRH6j6w/MoKCNC04tbDiQMWFbxha+1rIedjOGUOz0uKgbKbuphvBeTTtWkDf2N5mr1/kVI/4MP6Hi2+X4Px/s0G42pUFyHom1WuUn/igFWTIo5t5G9pSm4ltLWEeacEdRepkjoCgNkABaOA10B0QZIFab0HdURMdnEYiYIQ== tomas-rsa@harkema.io"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILLRj3s9oVwDREN5oO/lpYhs6ueYcEqHf8mN7dRR0UOS root@euro-mir.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@supermicro"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL68j0j9QNtaxySo9ysSV2n3xBcqc1aYzGFblwQvi1BQoQ4KIpCLkCxOx69yOdo/LwoCriyCmEEimqM0bEL3YZs="
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOgjI9ptMC39vQC84tiNOgU8LBpI05KeiLtNGT465wCL/L3DYNLOdOP6KRqUvUBVTdZP3YACUa17LQu3taPGhfQ= ShellFish@iPhone-18012024"
    ]
    ++ githubKeys;
in {
  options.user = with types; {
    name = mkOpt str "tomas" "The name to use for the user account.";

    keys = mkOpt (listOf str) keys "auth keys";
    #   fullName = mkOpt str "Tomas Harkema" "The full name of the user.";
    #   email = mkOpt str "tomas@harkema.io" "The email of the user.";
    #   initialPassword =
    #     mkOpt str "password"
    #     "The initial password to use when the user is first created.";
    #   icon =
    #     mkOpt (nullOr package) defaultIcon
    #     "The profile picture to use for the user.";
    #   prompt-init = mkBoolOpt true "Whether or not to show an initial message when opening a new shell.";
    #   extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    #   extraOptions =
    #     mkOpt attrs {}
    #     (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    security = {
      pam = {
        loginLimits = [
          {
            domain = "*";
            type = "soft";
            item = "nofile";
            value = "8192";
          }
        ];
        # services = {
        #   login.googleAuthenticator.enable = true;
        # };
      };
      sudo.wheelNeedsPassword = false;
    };

    environment.systemPackages = with pkgs; [];

    programs.zsh = {enable = true;};

    users.mutableUsers = mkDefault false;
    programs.fuse.userAllowOther = true;
    users.users.${config.user.name} = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "tomas";
      group = "${config.user.name}";
      extraGroups = ["networkmanager" "wheel" "rslsync" "users" "fuse" "disk" "plugdev" "dailout"];
      hashedPassword = "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";
      openssh.authorizedKeys.keys = keys;
      linger = true;
    };

    users.groups.${config.user.name} = {
      name = "${config.user.name}";
      members = ["${config.user.name}"];
    };

    users.groups = {
      agent = {};
      rslsync = lib.mkIf config.resilio.enable {};
    };
    users.users.agent = {
      isSystemUser = true;
      group = "agent";
      extraGroups = lib.mkIf config.resilio.enable ["rslsync"];
      openssh.authorizedKeys.keys = keys ++ ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnvSLFgBw3An9URn/X+UZ7Z0kkzUXDtL3dO9sr7iT/u"];
    };

    users.users.builder = {
      isSystemUser = true;
      group = "agent";
      # extraGroups = ["rslsync"];
      openssh.authorizedKeys.keys =
        keys
        ++ [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLZtRNaxKQwzBfC7xCjUgFl8/Zgg2dRLN6EIvx3wifh root@blue-fire"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOBloItNNcnAjlcBux/BJU0Dl9rry3SgR3VtGPK5LC6 tomas@blue-fire"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKKkjMLwP3DC+JnjbYc566gCYHUsE/k6ZAOy9AuKkKCH hydra@blue-fire"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn9lCVI1qwvLY/gQH0X3kqbxvNOSHExhPynUTPSWDmH hydra-queue-runner@blue-fire"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwoMVtxCQilu+k9A0KNwW6lJKWQqLqHE8R7NZtef8Wj root@blue-fire"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBmE+i7RminmrURhTsKdyj/Wo4MyXz6eHET3FixY2CAv builder@blue-fire"
        ];
    };

    users.users.root = {
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };

    # optional, useful when the builder has a faster internet connection than yours
    nix.extraOptions = ''
      builders-use-substitutes = true
    '';

    nix.settings = {
      extra-experimental-features = "nix-command flakes cgroups";
      trusted-users = ["root" "tomas" "builder"];

      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
        "https://blue-fire.ling-lizard.ts.net/attic/tomas/"
        "https://devenv.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "peerix-tomas-1:OBFTUNI1LIezxoFStcRyCHKi2PHExoIcZA0Mfq/4uJA="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "tomas:qzaaV24nfgwcarekICaYr2c9ZBFDQnvvydOywbwAeys="
      ];
    };
  };
}
