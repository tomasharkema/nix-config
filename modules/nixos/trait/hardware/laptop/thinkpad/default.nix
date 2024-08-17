{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.trait.hardware.laptop.thinkpad;
in {
  options.trait.hardware.laptop.thinkpad = {
    enable = mkEnableOption "laptop";
  };

  options = {
    services.fprintd = {
      enable = mkEnableOption "fprintd daemon and PAM module for fingerprint readers handling";
      package = mkOption {
        type = types.package;
        # default = fprintdPkg;
      };
    };
  };

  imports = with inputs; [
    nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
    nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity
  ];

  disabledModules = ["services/security/fprintd.nix"];

  config = mkIf cfg.enable {
    system.nixos.tags = ["thinkpad"];

    environment.systemPackages = with pkgs; [
      # modemmanager
      # modem-manager-gui
      # libmbim
      # libqmi
      tpacpi-bat
      sgx-ssl
      sgx-sdk
      # sgx-psw
    ];

    systemd.services = {
      open-fprintd-resume.enable = true;
      open-fprintd-suspend.enable = true;
    };

    services = {
      # tp-auto-kbbl.enable = true;
      # thinkfan.enable = true;
      fprintd = {
        enable = mkForce true;
        #   tod = {
        #     enable = true;
        #   };
      };
      open-fprintd.enable = true;
      python-validity.enable = true;
      fprintd.package = inputs.nixos-06cb-009a-fingerprint-sensor.localPackages.fprintd-clients;
    };

    home-manager.users.tomas.programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
      {package = thinkpad-thermal;}
      {package = fnlock-switch-thinkpad-compact-usb-keyboard;}
      {package = thinkpad-battery-threshold;}
    ];

    hardware.cpu.intel.sgx = {
      enableDcapCompat = true;
      provision = {
        enable = true;
      };
    };

    users.users.tomas.extraGroups = ["sgx" "sgx_prv"];
    boot.extraModprobeConfig = ''
      options thinkpad_acpi fan_control=1
    '';
    security.pam.services = {
      "gdm-fingerprint" = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      xscreensaver = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      "runuser" = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      "runuser-l" = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      su = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      "polkit-1" = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      passwd = {
        fprintAuth = true;
      };
      "systemd-user" = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      sudo = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      auth = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      login = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      vlock = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      "xscreenserver" = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      xlock = {
        # enableGnomeKeyring = true;
        fprintAuth = true;
      };
      passwd.enableGnomeKeyring = true;
    };
  };
}
