{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  mineral = pkgs.applyPatches {
    name = "mineral-patched";
    src = inputs.nix-mineral;
    # src = pkgs.fetchgit {
    #   url = "https://github.com/cynicsketch/nix-mineral.git";
    #   rev = "HEAD";
    #   sha256 = "sha256-VoxxCpr5DdSun0OpUtvH4XJ5WwENNK9e+uSyMjQIEoM=";
    # };
    patches = [./nm.patch];
  };
in {
  imports = [
    # "${mineral.out}/nix-mineral.nix"
  ];
  config = {
    system.build.mineral-patched = mineral;
    # boot.kernelParams = ["security=selinux"];
    # policycoreutils is for load_policy, fixfiles, setfiles, setsebool, semodile, and sestatus.
    environment.systemPackages = with pkgs; [
      policycoreutils
      libsemanage
      libsepol
      # setools
      libselinux
      # selinux-sandbox
    ];
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = mkForce 1;
      "kernel.sysrq" = 1;
      "kernel.unprivileged_userns_clone" = mkForce 1;
    };
    # build systemd with SELinux support so it loads policy at boot and supports file labelling
    systemd.package = pkgs.systemd.override {
      withSelinux = true;
      # withHomed = true;
    };
  };
}
