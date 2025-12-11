{
  config,
  lib,
  pkgs,
  ...
}
: {
  options.traits.hardware.network = {
    xgbe = {
      enable = lib.mkEnableOption "network xgb";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.traits.hardware.network.xgbe.enable {
      system.nixos.tags = [
        (lib.mkOrder 999 "xgbe")
      ];

      boot = {
        kernel.sysctl = {
          "net.core.rmem_max" = 67108864;
          "net.core.wmem_max" = 67108864;
          "net.ipv4.tcp_rmem" = "4096 87380 33554432";
          "net.ipv4.tcp_wmem" = "4096 65536 33554432";
          "net.ipv4.tcp_congestion_control" = "htcp";
          "net.ipv4.tcp_mtu_probing" = "1";
          "net.core.default_qdisc" = "fq";
        };
      };

      # networking.networkmanager = {
      #   dispatcherScripts = [
      #     {
      #       source = pkgs.writeText "ethtool-up.sh" ''
      #         ETHSPEED="$(cat /sys/class/net/$1/speed)"
      #         logger "$1 $ETHSPEED"
      #         if [[ "$ETHSPEED" == "10000" && "$2" == "up" ]]; then
      #           logger "$1 up"
      #           ${lib.getExe pkgs.ethtool} -K $1 tx on
      #           ${lib.getExe pkgs.ethtool} -K $1 rx on
      #           ${lib.getExe pkgs.ethtool} -K $1 tso on
      #           ${lib.getExe pkgs.ethtool} -K $1 gso on
      #           ${lib.getExe pkgs.ethtool} -K $1 sg on
      #         fi
      #       '';
      #       type = "basic";
      #     }
      #   ];
      # };
    })
  ];
}
