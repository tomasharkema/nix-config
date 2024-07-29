{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.apps.buildbot.worker;
in {
  options.apps.buildbot.worker = {
    enable = mkEnableOption "buildbot worker";
  };
  config = mkIf cfg.enable {
    age.secrets.buildbot-worker-password = {
      rekeyFile = ./buildbot-worker-password.age;
    };
    services.buildbot-nix.worker = {
      enable = true;
      workerPasswordFile = config.age.secrets.buildbot-worker-password.path;
      masterUrl = "tcp:host=silver-star-vm:port=${config.apps.buildbot.workerPort}";
      buildbotNixpkgs = pkgs.unstable; #inputs.unstable.legacyPackages."${pkgs.system}";
    };
  };
}
