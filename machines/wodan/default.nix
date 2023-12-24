{
  config,
  pkgs,
  ...
}: {
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  system.stateVersion = "23.11";
  programs.nix-ld.enable = true;
  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = true;
  };

  # programs.nix-ld.enable = true;
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
}
