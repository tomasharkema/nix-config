{ self, nixpkgs, pkgs, lib, home-manager, ... }: {
  hardware.enableAllFirmware = true;
  system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
  system.stateVersion = "23.11";
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" "x86_64-linux" ];
  imports = [
    ./packages.nix
    ../apps/resilio.nix
    ../apps/tailscale.nix
    # ./zsh.nix
    home-manager.nixosModules.default
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.tomas = {
    home.stateVersion = "23.11"; # Please read the comment before changing.

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    programs.htop.enable = true;
    programs.htop.settings.show_program_path = false;
    # programs.zsh.enable = true;
    home.packages = [
      # pkgs is the set of all packages in the default home.nix implementation
      pkgs.starship
    ];
    programs.starship = {
      enable = true;
      # settings = {
      #   add_newline = false;
      #   aws.disabled = false;
      #   gcloud.disabled = true;
      #   line_break.disabled = true;
      # };
    };
    home.file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      ".zshrc".text = ''
        ZSH_THEME="jonathan"
        # Uncomment the following line to enable command auto-correction.
        ENABLE_CORRECTION="true"
        # source "/opt/homebrew/opt/spaceship/spaceship.zsh"
      '';
    };
    programs.home-manager = { enable = true; };
    # programs.home-manager.enable = true;
    programs.helix.enable = true;
    # programs.htop.enable = true;
    programs.lazygit.enable = true;
    programs.lsd.enable = true;
    programs.jq.enable = true;
    programs.alacritty.enable = true;
    programs.skim.enable = true;

    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "thefuck"
          "autojump"
          "gitignore"
          "sudo"
          "macos"
          "zsh-autosuggestions"
          "colorize"
          "1password"
        ];
        theme = "jonathan";
      };
      enableAutosuggestions = true;
    };
  };

  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  security.sudo.wheelNeedsPassword = false;

  users.mutableUsers = false;
  nixpkgs.config.allowUnfree = true;
  users.users.tomas = {
    isNormalUser = true;
    description = "tomas";
    extraGroups = [ "networkmanager" "wheel" "rslsync" "tomas" ];
    hashedPassword =
      "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
    ];
  };

  services.eternal-terminal.enable = true;

  # users.users."tomas".hashedPassword =
  #   config.users.users."tomas".initialHashedPassword;

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { withCloud = true; };
    claimTokenFile = ../files/cloudtoken.conf;
  };

  system.autoUpgrade.enable = true;
  services.cockpit = {
    enable = true;
    port = 9090;
    settings = { WebService = { AllowUnencrypted = true; }; };
  };
  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # networking.networkmanager.unmanaged = [ "tailscale0" ];

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  # systemd.services.NetworkManager-wait-online.enable = false;

  nix.optimise.automatic = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.firewall = {
    # enable the firewall
    enable = true;

    #   # # allow the Tailscale UDP port through the firewall
    # allowedUDPPorts = [ 22 2022 9090 ];

    #   # # allow you to SSH in over the public internet
    # allowedTCPPorts = [ 22 2022 9090 ];
  };
}
