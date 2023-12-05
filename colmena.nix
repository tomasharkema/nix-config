{ nixpkgs, ... }: {

  meta = {
    nixpkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ ];
    };
    nodeNixpkgs = {
      utm = import nixpkgs {
        system = "aarch64-linux";
        overlays = [ ];
      };
    };
  };

  defaults = { pkgs, ... }: {
    imports = [ ./packages.nix ./overlays/defaults.nix ];
  };

  utm-nixos = { pkgs, modulesPath, ... }: {

    imports = [ ./overlays/desktop.nix ];

    networking.hostName = "utm-nixos";
    deployment.tags = [ "vm" ];
    nixpkgs.system = "aarch64-linux";
    deployment.buildOnTarget = true;
    deployment = {
      targetHost = "10.211.70.5";
      targetUser = "root";
    };
    boot.isContainer = true;
  };

  utm-ferdorie = { pkgs, modulesPath, ... }: {

    imports = [ ./overlays/desktop.nix ];

    networking.hostName = "utm-ferdorie";
    deployment.tags = [ "vm" ];
    nixpkgs.system = "aarch64-linux";
    deployment.buildOnTarget = true;
    deployment = {
      targetHost = "100.119.250.94";
      targetUser = "root";
    };
    boot.isContainer = true;
  };

  enceladus = { pkgs, ... }: {
    networking.hostName = "enceladus";
    deployment.tags = [ "bare" ];
    deployment.buildOnTarget = true;
    deployment = {
      targetHost = "enceladus";
      targetUser = "root";
    };
    boot.isContainer = true;
  };

  hyperv = { pkgs, ... }: {
    imports = [ ./overlays/desktop.nix ];

    networking.hostName = "hyperv-nixos";
    deployment.tags = [ "vm" ];

    deployment.buildOnTarget = true;
    deployment = {
      targetHost = "100.64.161.30";
      targetUser = "root";
    };

    virtualisation.hypervGuest.enable = true;

    boot.isContainer = true;
  };

  cfserve = { pkgs, ... }: {
    imports = [ ./overlays/desktop.nix ];

    deployment.tags = [ "bare" ];
    networking.hostName = "cfserve";

    deployment.buildOnTarget = true;
    deployment = {
      targetHost = "cfserve.ling-lizard.ts.net";
      targetUser = "root";
    };

    boot.isContainer = true;
  };

  unraidferdorie = { pkgs, ... }: {
    deployment.tags = [ "vm" ];
    networking.hostName = "unraidferdorie";

    deployment.buildOnTarget = true;
    deployment = {
      targetHost = "100.81.109.156";
      targetUser = "root";
    };

    boot.isContainer = true;
  };

}
