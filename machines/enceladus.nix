{ config, pkgs, modulesPath, ... }: {
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nixpkgs.system = "x86_64-linux";
  imports = [
    # ./overlays/efi.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    ../overlays/desktop.nix
    ../apps/steam.nix
  ];
  networking.hostName = "enceladus";
  _module.check = false;
  deployment.tags = [ "bare" ];
  deployment = {
    targetHost = "100.83.6.88";
    # targetHost = "192.168.178.46";
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/92b9539f-d0c2-47fb-80da-3b7cd0ab6197";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0146-866A";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
