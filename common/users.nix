{ pkgs
  # , nixpkgs
, ...
}:
let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas@harkema.io"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRzOjHZdqy0NfDPi9+9onjJKYQA23+0v+a0nnQ0VgvMCEPyHzM3UQwrq6RNNXt/8OQ1U89cFz726mL/nNljeSvfFodmSukk5h7D+5pQwTLTVQprmjumHJU8S6JgW8d2RYbvUlPxOed4kPkBD414qQoi+nQTynDPPKnIzFWuLEgDmSsS0KMb+l6Y0AdC9X+i3lMT1cK8EqsqIDjGvnFaTyXisr/yjdx3nR/1X9qD1PXQmbnw0dRa7EJZ5kQ9J8Zllju3qe98LibD8Kgsu0QeXYf3Hwm18JWq5uJdKobeyditg2deIfKwXk8fgk8S7lfZwaR+WLDhh3cU+Fo43BRgl9FJx04GjXjqMs9OOO5xVsLF+ch+EdMPwO2ag7lYxXfBQNwkNDOk6PSoaHwSXrnOMQIgo2zUh4W689pL8AbMGnvLvQSo106EtKB1WTJF1ZjvSBpYNeN9TUxZ3RrnbDsJDT/gQ6NeUTFa5/wliiHjWQ6N4p8m87kIlGQRzjEg70YfJjPQ/6KRH6j6w/MoKCNC04tbDiQMWFbxha+1rIedjOGUOz0uKgbKbuphvBeTTtWkDf2N5mr1/kVI/4MP6Hi2+X4Px/s0G42pUFyHom1WuUn/igFWTIo5t5G9pSm4ltLWEeacEdRepkjoCgNkABaOA10B0QZIFab0HdURMdnEYiYIQ== tomas-rsa@harkema.io"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILLRj3s9oVwDREN5oO/lpYhs6ueYcEqHf8mN7dRR0UOS root@euro-mir.local"
  ];
in
{

  programs.zsh = { enable = true; };
  users.users.tomas.shell = pkgs.zsh;

  users.mutableUsers = false;

  users.users.tomas = {
    isNormalUser = true;
    description = "tomas";
    group = "tomas";
    extraGroups = [ "networkmanager" "wheel" "rslsync" ];
    hashedPassword = "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";

    openssh.authorizedKeys.keys = keys;
  };
  users.groups.tomas = {
    name = "tomas";
    members = [ "tomas" ];
  };

  users.users.root =
    {
      openssh.authorizedKeys.keys = keys;
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
    access-tokens = [ "github.com=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" ];
  };
}
