{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hardware.sgx;
in {
  options.traits.hardware.sgx = {
    enable = lib.mkEnableOption "sgx";
  };

  config = lib.mkIf cfg.enable {
    hardware.cpu.intel.sgx = {
      enableDcapCompat = true;
      provision = {
        enable = true;
      };
    };

    services = {
      aesmd = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      sgx-ssl
      sgx-sdk
    ];

    users.users.tomas.extraGroups = [
      "sgx"
      "sgx_prv"
    ];

    # boot = {
    #   kernelModules = [ "isgx" ];
    #   initrd.kernelModules = [ "isgx" ];
    # };
  };
}
