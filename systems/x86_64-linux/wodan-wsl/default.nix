{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.nixos-wsl.nixosModules.wsl];

  config = {
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
    # tailscale.enable = false;
    services.udev.enable = lib.mkForce false;

    system.stateVersion = "23.11";

    networking = {
      hostName = lib.mkDefault "wodan-wsl";

      #   firewall = {
      #     enable = false;
      #   };
      #   useDHCP = lib.mkDefault true;
    };

    wsl = {
      enable = true;

      wslConf = {
        automount = {
          enabled = true;

          root = "/mnt";
        };

        interop = {
          enabled = true;
        };
      };
      # defaultUser = "tomas";

      startMenuLaunchers = true;

      interop = {
        register = true;
      };

      # Enable integration with Docker Desktop (needs to be installed)
      # docker-desktop.enable = true;
    };

    # Enable nix flakes
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    programs.zsh = {
      enable = true;
    };

    users.defaultUserShell = pkgs.zsh;

    networking.nftables.enable = lib.mkForce false;
  };
}
