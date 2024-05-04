{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; {
  options.user = with types; {
    name = mkOpt str "tomas" "The name to use for the user account.";

    # keys = mkOpt (listOf str) keys "auth keys";
    fullName = mkOpt str "Tomas Harkema" "The full name of the user.";
    email = mkOpt str "tomas@harkema.io" "The email of the user.";
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

      openssh.authorizedKeys.keyFiles = [pkgs.custom.authorized-keys];
      linger = true;
      uid = 1000;
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
      openssh.authorizedKeys.keyFiles = [pkgs.custom.authorized-keys];
      uid = 1099;
    };

    users.users.builder = {
      isSystemUser = true;
      group = "agent";
      # extraGroups = ["rslsync"];
      uid = 1098;
      openssh.authorizedKeys.keyFiles = [pkgs.custom.authorized-keys];
    };

    users.users.root = {
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [pkgs.custom.authorized-keys];
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
        "https://nix-cache.harke.ma/tomas/"
        "https://devenv.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "peerix-tomas-1:OBFTUNI1LIezxoFStcRyCHKi2PHExoIcZA0Mfq/4uJA="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "tomas:yyzVkcCGYkbf3kzM80H45L70w7LS6M8mDQL+x+GbfUs="
      ];
    };
  };
}
