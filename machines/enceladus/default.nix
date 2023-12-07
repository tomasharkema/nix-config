{ disko, config, pkgs, modulesPath, lib, ... }: {
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nixpkgs.system = "x86_64-linux";
  imports = [
    # ./overlays/efi.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../overlays/desktop.nix
    ../../apps/steam.nix
    "${
      builtins.fetchTarball {
        url = "https://github.com/nix-community/disko/archive/master.tar.gz";
        sha256 = "sha256:0khjn8kldipsr50m15ngnprzh1pzywx7w5i8g36508l4p7fbmmlm";
      }
    }/module.nix"
    ./disk-config.nix
    {
      _module.args.disks =
        [ "/dev/disk/by-id/ata-HFS128G39TND-N210A_FI71N041410801J4Y" ];
    }
  ];
  networking.hostName = "enceladus";
  _module.check = false;
  deployment.tags = [ "bare" ];
  deployment = {
    # targetHost = "100.94.108.52";
    targetHost = "192.168.178.46";
    targetUser = "root";
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  #   environment.systemPackages = with pkgs; [ nvtop ];
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  systemd.services.netdata.path = [ pkgs.linuxPackages.nvidia_x11 ];
  services.netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
    nvidia_smi: yes
  '';

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  services.btrfs.autoScrub.enable = true;
}
