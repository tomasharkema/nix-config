{
  lib,
  config,
  ...
}: let
  cfg = config.traits.hardware.nfs;
in {
  options.traits.hardware.nfs = {
    enable = lib.mkEnableOption "nfs";

    #   machines = {
    #     silver-star.enable = mkEnableOption "nfs silver-star";
    #     dione.enable = mkEnableOption "nfs dione";
    #   };
  };

  # autofs!
  config = lib.mkIf false {
    # cfg.enable {
    assertions = [];

    services.rpcbind.enable = true;

    systemd = let
      mounts =
        (lib.optionals cfg.machines.silver-star.enable [
          {
            what = "192.168.0.100:/mnt/user/domains";
            where = "/mnt/unraid/domains";
          }
          {
            what = "192.168.0.100:/mnt/user/appdata";
            where = "/mnt/unraid/appdata";
          }
          {
            what = "192.168.0.100:/mnt/user/appdata_ssd";
            where = "/mnt/unraid/appdata_ssd";
          }
          {
            what = "192.168.0.100:/mnt/user/appdata_disk";
            where = "/mnt/unraid/appdata_disk";
          }
          {
            what = "192.168.0.100:/mnt/user/data";
            where = "/mnt/unraid/data";
          }
          {
            what = "192.168.0.100:/mnt/user/downloads";
            where = "/mnt/unraid/downloads";
          }
        ])
        ++ (lib.optionals cfg.machines.dione.enable [
          {
            what = "192.168.178.3:/volume1/homes";
            where = "/mnt/dione";
          }
        ]);
    in {
      mounts = lib.lists.forEach mounts (mnt:
        mnt
        // {
          type = "nfs";
          mountConfig = {Options = "noatime";};
        });
      automounts = lib.lists.forEach mounts (mnt: {
        wantedBy = ["multi-user.target"];
        automountConfig = {TimeoutIdleSec = "600";};
        where = mnt.where;
      });
    };
  };
}
