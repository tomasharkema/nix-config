{ pkgs, lib, ... }:
with pkgs;
let
  darwin-build =
    #lib.mkIf pkgs.stdenv.isDarwin
    writeShellScriptBin "darwin-build" ''
      darwin-rebuild switch --flake ~/Developer/nix-config
    '';
in {
  config = {
    environment.systemPackages = [ darwin-build ];

    # nix.buildMachines = [
    # {
    #   hostName = "blue-fire";
    #   systems = ["aarch64-linux" "x86_64-linux"];
    #   maxJobs = 4;
    #   supportedFeatures = ["kvm" "benchmark" "big-parallel"];
    #   speedFactor = 100;
    # }
    # ];
  };
}
