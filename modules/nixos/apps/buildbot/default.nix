{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.apps.buildbot;
in {
  imports = with inputs; [
    buildbot-nix.nixosModules.buildbot-master
    buildbot-nix.nixosModules.buildbot-worker

    ./buildbot-master.nix
  ];

  disabledModules = ["services/continuous-integration/buildbot/master.nix"];

  options.apps.buildbot = {
    enable = mkEnableOption "buildbot";

    workerPort = mkOption {default = "9988";};
  };

  config = mkIf cfg.enable {
    age.secrets = {
      buildbot-github-app = {
        rekeyFile = ./buildbot-github-app.age;
        # owner = "buildbot";
        # mode = "777";
      };
      buildbot-github-oauth = {
        rekeyFile = ./buildbot-github-oauth.age;
        # owner = "buildbot";
        # mode = "777";
      };
      buildbot-webhook = {
        rekeyFile = ./buildbot-webhook.age;
        # mode = "777";
      };
      buildbot-workers-json = {
        rekeyFile = ./buildbot-workers-json.age;
      };
    };
    services = {
      buildbot-master = {
        buildbotUrl = mkForce "https://buildbot.harkema.io/";
        pbPort = "'tcp:${cfg.workerPort}:interface=0.0.0.0'";
      };
      buildbot-nix = {
        master = {
          enable = true;
          domain = "buildbot.harkema.io";
          admins = ["tomasharkema"];
          outputsPath = "/var/www/buildbot/nix-outputs";
          buildbotNixpkgs = pkgs.unstable;

          workersFile = config.age.secrets.buildbot-workers-json.path;

          github = {
            topic = "buildbot-blue-fire";
            authType.app = {
              id = 955900;
              secretKeyFile = config.age.secrets.buildbot-github-app.path;
            };
            # authType.legacy = {
            #   tokenFile = config.age.secrets.github-token.path;
            # };
            oauthId = "Iv23liipuBZrzJdgvCvc";
            oauthSecretFile = config.age.secrets.buildbot-github-oauth.path;
            webhookSecretFile = config.age.secrets.buildbot-webhook.path;
          };
        };
      };
    };
  };
}
