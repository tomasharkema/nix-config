{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.services.automounts;
  machines = inputs.self.machines.excludingSelf config;
in {
  options.services.automounts = {
    enable = lib.mkOption {
      type =
        lib.types.bool;
      default = true;
      description = "automounts";
    };
  };

  config = lib.mkIf cfg.enable {
    services.autofs = {
      enable = true;
      debug = true;
      autoMaster = let
        sshFsLines =
          map (machine: "${machine}  -fstype=fuse,port=22,idmap=user,rw,allow_other,noatime :sshfs\\#tomas@${machine}\\:/")
          machines;
        sshFsMapConf = pkgs.writeText "sshfs.conf" (lib.concatStringsSep "\n" sshFsLines);
        nfsConf = let
          common = "-rw,soft,intr,rsize=8192,wsize=8192,anonuid=1000,anongid=1000";
        in
          pkgs.writeText "nfs.conf" ''
            dione-tomas ${common} 192.168.1.102:/volume1/tomas
            dione-downloads ${common} 192.168.1.102:/volume1/downloads
            isos ${common} 192.168.1.102:/volume1/isos
          '';
      in ''
        /mnt/servers/sshfs file:${sshFsMapConf} --timeout=30
        /mnt/servers/nfs file:${nfsConf} --timeout=30
      '';
    };
    # [Unit]
    # Description=SSHFS mount
    # Requires=network-online.target

    # [Mount]
    # What=sshfs#MYUSER@192.168.8.3:/stuff/
    # Where=/media/user/stuff/
    # Type=sshfs
    # Options=allow_other,noatime,port=22,IdentityFile=/home/user/.ssh/id_rsa

    # systemd = {
    #   automounts =
    #     map (machine: {
    #       description = "sshfs automount ${machine}";
    #       where = "/mnt/servers/${machine}";
    #       enable = true;
    #       wantedBy = ["multi-user.target"];
    #     })
    #     machines;
    #   mounts =
    #     map (machine: {
    #       # name = "automount-${machine}";
    #       description = "sshfs mount ${machine}";
    #       where = "/mnt/servers/${machine}";
    #       what = "sshfs#tomas@${machine}:/";
    #       type = "sshfs";
    #       options = "allow_other,noatime,port=22,reconnect,users,noauto,x-systemd.automount";
    #       requires = ["network-online.target"];
    #     })
    #     machines;
    # };
  };
}
