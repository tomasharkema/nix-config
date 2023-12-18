{ config
, # , nixpkgs
  # ,
  pkgs
, inputs
, lib
, ...
} @ attrs:
let
  # lib = nixpkgs.lib;
  common = import ../packages/common.nix (attrs);
  gui = import ../packages/gui.nix (attrs);
in
{
  # nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  # system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
  system.stateVersion = "23.11";
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" "x86_64-linux" ];
  imports = [
    ../apps/resilio.nix
    ../apps/tailscale
    ./users.nix
    ../apps/cockpit.nix
  ];

  environment.systemPackages = common ++ gui;

  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  services.eternal-terminal.enable = true;

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  age.secrets."netdata" = { file = ../secrets/netdata.age; };
  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { withCloud = true; };
    claimTokenFile = config.age.secrets."netdata".path;
  };
  programs.ssh.startAgent = true;
  system.autoUpgrade.enable = true;

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "systemd"
          "collectd"
          "statsd"
        ];
      };
      # systemd = {
      #   enable = true;
      #   port = 9003;
      # };
      # statsd = {
      #   enable = true;
      #   port = 9004;
      # };
    };
  };

  # services.cadvisor =
  #   {
  #     enable = true;

  #     port = 9005;
  #   };

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  # systemd.services.NetworkManager-wait-online.enable = false;

  nix.optimise.automatic = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.fwupd.enable = true;
  networking.firewall = {
    enable = true;
    # enable = false;
  };

  services.avahi.extraServiceFiles = {
    ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
  };

  environment.interactiveShellInit =
    let
      attic-bin = lib.attrsets.getBin inputs.attic.packages.${pkgs.system}.default;
      attic-script = (pkgs.writeShellScriptBin "attic-script" ''
        ${lib.attrsets.getBin attic-bin}/bin/attic login tomas https://nix-cache.harke.ma $(cat ${config.age.secrets.attic-key.path})
        ${lib.attrsets.getBin attic-bin}/bin/attic use tomas:tomas
      '');
    in
    ''
      ${attic-script}/bin/attic-script
      #   mkdir -p ~/.1password || true
      #   ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock /Users/tomas/.1password/agent.sock || true
      #   export SSH_AUTH_SOCK=/Users/tomas/.1password/agent.sock
    '';


  systemd.services.attic-watch =
    let
      attic-bin = lib.attrsets.getBin inputs.attic.packages.${pkgs.system}.default;
      attic-script = (pkgs.writeShellScriptBin "attic-script" ''
        ${lib.attrsets.getBin attic-bin}/bin/attic login tomas https://nix-cache.harke.ma $(cat ${config.age.secrets.attic-key.path})
        ${lib.attrsets.getBin attic-bin}/bin/attic use tomas:tomas
        ${lib.attrsets.getBin attic-bin}/bin/attic watch-store tomas:tomas
      '');
    in
    {
      enable = true;
      description = "attic-watch";
      unitConfig = {
        Type = "simple";
        StartLimitIntervalSec = 500;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
        MemoryLimit = "1G";
      };
      script = "${lib.attrsets.getBin attic-script}/bin/attic-script";
      wantedBy = [ "multi-user.target" ];
      path = [ attic-bin attic-script ];
      environment = {
        ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
      };
    };
}
