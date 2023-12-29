{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.nixos-wsl.nixosModules.wsl];

  config = {
    # tailscale.enable = false;
    services.udev.enable = lib.mkForce false;

    boot.binfmt.emulatedSystems = ["aarch64-linux"];
    system.stateVersion = "23.11";
    programs.nix-ld.enable = true;

    networking = {
      hostName = lib.mkDefault "wodan-wsl";

      firewall = {
        enable = false;
      };
      useDHCP = lib.mkDefault true;
    };

    wsl = {
      enable = true;
      automountPath = "/mnt";
      defaultUser = "tomas";
      startMenuLaunchers = true;

      # Enable integration with Docker Desktop (needs to be installed)
      # docker-desktop.enable = true;
    };

    # Enable nix flakes
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    programs.git.enable = true;
    programs.git.config = {
      user = {
        name = "Tomas Harkema";
        email = "tomas@harkema.io";
      };
    };

    environment.systemPackages = with pkgs; [wget nodejs curl zstd];

    programs.zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
      };
    };

    users.defaultUserShell = pkgs.zsh;

    services.openssh.enable = true;
  };
}
