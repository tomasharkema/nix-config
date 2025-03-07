{
  config,
  pkgs,
  lib,
  ...
}: {
  options.apps.ollama = {enable = lib.mkEnableOption "ollama";};

  config = lib.mkIf config.apps.ollama.enable {
    services = {
      ollama = {
        enable = true;
        acceleration = "cuda";
        host = "0.0.0.0";
        # loadModels = ["llama3.1:8b" "starcoder2:3b"];
      };
      open-webui = {
        #enable = true;
        host = "0.0.0.0";
      };
    };
  };
}
