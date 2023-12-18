{ pkgs
  # , nixpkgs
, ...
}: {

  programs.zsh = { enable = true; };
  users.users.tomas.shell = pkgs.zsh;

  users.mutableUsers = false;

  users.users.tomas = {
    isNormalUser = true;
    description = "tomas";
    extraGroups = [ "networkmanager" "wheel" "rslsync" ];
    hashedPassword = "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@supermicro"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRn81Pxfg4ttTocQnTUWirpC1QVeJ5bfPC63ET9fNVa root@supermicro"
    ];
  };
  users.groups.tomas = {
    name = "tomas";
    members = [ "tomas" ];
  };

  security.sudo.wheelNeedsPassword = false;

  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  nix.settings = {
    extra-experimental-features = "nix-command flakes";
    # distributedBuilds = true;
    trusted-users = [ "root" "tomas" ];
    extra-substituters = [
      "https://nix-cache.harke.ma/tomas"
      "https://cache.nixos.org/"
    ];
    extra-binary-caches = [
      "https://nix-cache.harke.ma/tomas"
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [

      "nix-cache.harke.ma:2UhS18Tt0delyOEULLKLQ36uNX3/hpX4sH684B+cG3c="
    ];
    access-tokens = [ "github.com=***REMOVED***" ];
  };
}
