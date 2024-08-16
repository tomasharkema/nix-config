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

  imports = with inputs; [
    nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
    nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity
  ];

  config = mkIf cfg.enable {
    system.nixos.tags = ["thinkpad"];

    environment.systemPackages = with pkgs; [
      # modemmanager
      # modem-manager-gui
      # libmbim
      # libqmi
      tpacpi-bat
      # sgx-ssl
      # sgx-sdk
      # sgx-psw
    ];

    services = {
      # tp-auto-kbbl.enable = true;
      # thinkfan.enable = true;
      # fprintd = {
      #   enable = true;
      #   tod = {
      #     enable = true;
      #     driver = inputs.nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
      #       calib-data-file = ./calib-data.bin;
      #     };
      #   };
      # };
      open-fprintd.enable = true;
      python-validity.enable = true;
      # fprintd.package = inputs.nixos-06cb-009a-fingerprint-sensor.localPackages.fprintd-clients;
      aesmd = {
        enable = true;
        settings = {
          defaultQuotingType = "ecdsa_256";
          whitelistUrl = "http://whitelist.trustedservices.intel.com/SGX/LCWL/Linux/sgx_white_list_cert.bin";
        };
      };
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
      # passwd.enableGnomeKeyring = true;
    };
  };
}
