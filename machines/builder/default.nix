{ nix-darwin
, nixpkgs
, lib
, ...
}@inputs:
let

  inherit (nix-darwin.lib) darwinSystem;
  system = "aarch64-darwin";
  pkgs = nixpkgs.legacyPackages."${system}";
  linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] system;

  darwin-builder = nixpkgs.lib.nixosSystem {
    system = linuxSystem;
    modules = [
      "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
      {
        # imports = [ ../../apps/tailscale ];
        boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
        virtualisation = {
          host.pkgs = pkgs;
          useNixStoreImage = true;
          writableStore = true;
          cores = 4;

          darwin-builder = {
            workingDirectory = "/var/lib/darwin-builder";
            diskSize = 20000;
            memorySize = 4096;
          };
        };

        networking.useDHCP = true;
        # environment.systemPackages = with pkgs; [ wget curl ];
      }
    ];
  };
  inherit (pkgs) stdenvNoCC;
  launchcontrol = stdenvNoCC.mkDerivation
    (finalAttrs: {
      pname = "LaunchControl";
      version = "2.5.1";

      src = fetchTarball {
        # name = "LaunchControl-2.5.1.tar.xz";
        url = "https://www.soma-zone.com/download/files/LaunchControl-2.5.1.tar.xz";
        sha256 = "sha256:0zj4inl00sqrckzdlcym5af8s0rqq8dyp7fwr4cyndgz7yvkfvz2";
      };

      dontPatch = true;
      dontConfigure = true;
      dontBuild = true;
      dontFixup = true;

      nativeBuildInputs = [ pkgs.xz ];

      # sourceRoot = "LaunchControl.app";

      installPhase = ''
        runHook preInstall

        mkdir -p $out/Applications/LaunchControl.app
        cp -R . $out/Applications/LaunchControl.app

        runHook postInstall
      '';

      meta = with lib; {
        # description = "Take Control of Your Wireless Devices on macOS";
        # longDescription = ''
        #   Open your AirPods case next to your Mac to see the status right away, just like it works on your iPhone or iPad.
        #   AirBuddy lives in your Menu Bar and can also show battery information for your iPhone, iPad, Apple Watch, Mouse, Keyboard, and more.
        # '';
        # homepage = "https://v2.airbuddy.app";
        # changelog = "https://support.airbuddy.app/articles/airbuddy-2-changelog";
        # license = with licenses; [ unfree ];
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        maintainers = with maintainers; [ stepbrobd ];
        platforms = [ "aarch64-darwin" "x86_64-darwin" ];
      };
    });
in

{
  nix.distributedBuilds = true;

  nix.buildMachines = [
    {
      hostName = "builder@linux-builder";
      system = linuxSystem;
      maxJobs = 4;
      supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
      sshKey = "/var/lib/darwin-builder/keys/builder_ed25519";
      speedFactor = 100;
    }
    {
      hostName = "builder@linux-builder";
      system = "x86_64-linux";
      maxJobs = 4;
      supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
      sshKey = "/var/lib/darwin-builder/keys/builder_ed25519";
      speedFactor = 100;
    }
  ];

  launchd.daemons.darwin-builder = {
    command = "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/darwin-builder.log";
      StandardErrorPath = "/var/log/darwin-builder.log";
    };
  };

  environment.systemPackages = lib.mkIf stdenvNoCC.isDarwin [ launchcontrol ];
}
