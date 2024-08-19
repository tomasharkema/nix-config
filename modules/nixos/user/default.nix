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
      extraGroups = [
        "networkmanager"
        "wheel"
        "rslsync"
        "users"
        "fuse"
        "disk"
        "plugdev"
        "dailout"
        "audio"
        "video"
      ];
      initialHashedPassword = "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";

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

    users.users.root = {
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [pkgs.custom.authorized-keys];
    };

    # optional, useful when the builder has a faster internet connection than yours
    # nix.extraOptions = ''
    #   builders-use-substitutes = true
    # '';

    programs.ccache = {
      enable = true;
      packageNames = [
        "linuxPackages_cachyos.kernel"
        "linuxPackages_xanmod_stable.kernel"
        "linuxPackages_latest.kernel"
        "ffmpeg"
        "ffmpeg-full"
      ];
    };

    nixpkgs.overlays = [
      (self: super: {
        linuxPackages_latest.kernel = builtins.trace "KERNEL CCACHE LATEST" super.linuxPackages_latest.kernel.override {
          stdenv = builtins.trace "KERNEL CCACHE LATEST STDENV" self.ccacheStdenv;
        };
        linuxPackages_cachyos.kernel = builtins.trace "KERNEL CCACHE CACHOS" super.linuxPackages_cachyos.kernel.override {
          stdenv = builtins.trace "KERNEL CCACHE CACHOS STDENV" self.ccacheStdenv;
        };
        linuxPackages_xanmod_stable.kernel = builtins.trace "KERNEL CCACHE XANMOD" super.linuxPackages_xanmod_stable.kernel.override {
          stdenv = builtins.trace "KERNEL CCACHE XANMOD STDENV" self.ccacheStdenv;
        };
      })
    ];

    nix.settings = {
      extra-sandbox-paths = [config.programs.ccache.cacheDir];

      use-cgroups = true;
      extra-experimental-features = "nix-command flakes cgroups";

      trusted-users = ["root" "tomas" "builder"];
      # trustedBinaryCaches = ["https://cache.nixos.org"];
      # binaryCaches = ["https://cache.nixos.org"];

      # extra-substituters = [
      #   "https://nix-gaming.cachix.org"
      #   "https://nix-community.cachix.org"
      #   "https://nix-cache.harke.ma/tomas/"
      #   "https://devenv.cachix.org"
      #   "https://cuda-maintainers.cachix.org"
      # ];
      # extra-trusted-public-keys = [
      #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      #   "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      #   "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      #   "tomas:hER/5A08v05jH8GnQUZRrh33+HDNbeiJj8z/8JY6ZvI="
      #   "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      #   "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      # ];
    };
  };
}
