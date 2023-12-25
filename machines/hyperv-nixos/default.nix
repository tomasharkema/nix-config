{lib, ...}: {
  nixpkgs.system = "x86_64-linux";
  imports = [
    ../../common/quiet-boot.nix
    # ../../common/game-mode.nix
    ../../apps/desktop.nix
    # ../../apps/steam.nix
    ./hardware-configuration.nix
    # ./overlays/efi.nix
  ];
  nixpkgs.config.allowUnfree = true;
  networking.hostName = "hyperv-nixos";
  networking.hostId = "a5a1dad6";

  services.resilio = {
    enable = lib.mkForce false;
  };
  boot.growPartition = true;

  # deployment.tags = [ "vm" ];
  # deployment = {
  #   targetHost = "100.64.161.30";
  #   # targetHost = "192.168.1.73";
  #   targetUser = "root";
  # };

  # environment.systemPackages = with pkgs;
  #   [ linuxKernel.packages.linux_6_1.vm-tools ];
  boot.bootspec.enable = true;

  #   boot.loader.systemd-boot.enable = true;
  #   boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.devices = ["nodev"];

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable =
    true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable =
    true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  users.users."tomas".extraGroups = ["tss"];
  # virtualisation.azure.agent.enable = true;

  networking.firewall = {
    enable = false;
    # enable = true;
  };

  fileSystems."/".device = lib.mkDefault "/dev/sda";
  # fileSystems."/boot".device = lib.mkForce "/dev/disk/by-label/ESP";
}
