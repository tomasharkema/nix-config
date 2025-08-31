{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.traits.hardware.laptop.thinkpad;

  tod-firmware = pkgs.fetchurl {
    url = "https://download.lenovo.com/pccbbs/mobiles/nz3gf07w.exe";
    sha256 = "1vvhcbd2dai2rysk90iq8lf26j2r8mi1hf4arhclb797w5pzmy60";
  };

  thinkpad-bat-rules = pkgs.stdenv.mkDerivation rec {
    pname = "thinkpad-thresholds-udev";
    version = "main";

    src = pkgs.fetchurl {
      url = "https://gitlab.com/marcosdalvarez/thinkpad-battery-threshold-extension/-/raw/main/others/99-thinkpad-thresholds-udev.rules";
      sha256 = "0gxb1cvh4vazc79bcqal7w825xy44hjj3n21s95xkrkkqsqpm8ar";
    };

    phases = ["installPhase"];

    buildInputs = [pkgs.coreutils];

    installPhase = ''
      install -D $src $out/etc/udev/rules.d/99-thinkpad-thresholds-udev.rules
      substituteInPlace $out/etc/udev/rules.d/99-thinkpad-thresholds-udev.rules \
        --replace-fail "/bin/chmod" "${pkgs.coreutils}/bin/chmod"
    '';
  };
in {
  options.traits.hardware.laptop.thinkpad = {
    enable = lib.mkEnableOption "laptop thinkpad";
  };

  # options = {
  #   services.fprintd = {
  #     enable = lib.mkEnableOption "fprintd daemon and PAM module for fingerprint readers handling";
  #     package = lib.mkOption {
  #       type = lib.types.package;
  #       # default = fprintdPkg;
  #     };
  #   };
  # };

  imports = with inputs; [
    # nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
    # nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity
    nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
  ];

  # disabledModules = ["services/security/fprintd.nix"];

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["thinkpad"];

    environment = {
      etc."tod/nz3gf07w.exe".source = tod-firmware;

      systemPackages = with pkgs; [
        modemmanager
        modem-manager-gui
        libmbim
        libqmi
        tpacpi-bat
        # custom.lenovo-wwan-unlock
        # sgx-psw
      ];
    };
    hardware.trackpoint.enable = true;

    systemd = {
      packages = [
        pkgs.modemmanager
        # pkgs.custom.lenovo-wwan-unlock
      ];
      # services = {
      #   open-fprintd-resume.enable = true;
      #   open-fprintd-suspend.enable = true;
      # };

      services = {
        print-restart = {
          after = [
            "hibernate.target"
            "hybrid-sleep.target"
            "suspend.target"
            "suspend-then-hibernate.target"
          ];
          wantedBy = [
            "hibernate.target"
            "hybrid-sleep.target"
            "suspend.target"
            "suspend-then-hibernate.target"
          ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.systemd}/bin/systemctl --no-block restart python3-validity.service open-fprintd.service";
          };
        };
      };
    };
    services = {
      "06cb-009a-fingerprint-sensor" = {
        enable = true;
        backend = lib.mkDefault "python3-validity";
        # backend = "libfprint-tod";
        # calib-data-file = ./calib-data.bin;
      };

      # tp-auto-kbbl.enable = true;
      # thinkfan.enable = true;
      # fprintd = {
      #   enable = lib.mkForce true;
      #   package = pkgs.fprintd-tod.overrideAttrs (old: {
      #     dontStrip = true;
      #   });
      #   tod = {
      #     enable = true;
      #     # driver = pkgs.libfprint-2-tod1-vfs0090.overrideAttrs (old: {
      #     #   dontStrip = true;
      #     # });
      #     driver =
      #       (inputs.nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch
      #         {
      #           calib-data-file = ./calib-data.bin;
      #         })
      #       .overrideAttrs (old: {
      #         dontStrip = true;
      #         patches = old.patches ++ [./vdev.patch];
      #       });
      #   };
      # };
      # open-fprintd.enable = true;
      # python-validity.enable = true;
      # fprintd.package = inputs.nixos-06cb-009a-fingerprint-sensor.localPackages.fprintd-clients;

      udev = {
        extraRules = ''
          SUBSYSTEM=="usb", ATTRS{idVendor}=="06cb", ATTRS{idProduct}=="009a", ATTRS{dev}=="*", TEST=="power/control", ATTR{power/control}="auto", MODE="0660", GROUP="plugdev"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="06cb", ATTRS{idProduct}=="009a", ENV{LIBFPRINT_DRIVER}="vfs009"
        '';

        packages = [
          pkgs.modemmanager
          thinkpad-bat-rules
        ];
      };
      dbus.packages = [pkgs.modemmanager];
    };

    home-manager.users.tomas.programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
      {package = thinkpad-thermal;}
      # {package = fnlock-switch-thinkpad-compact-usb-keyboard;}
      {package = thinkpad-battery-threshold;}
    ];

    # boot = {
    #   extraModprobeConfig = ''
    #     options thinkpad_acpi fan_control=1
    #   '';
    # };
  };
}
