{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.services.automounts;
  machines = inputs.self.servers;
in {
  options.services.automounts = {
    enable = mkOption {
      type =
        types.bool;
      default = true;
      description = "automounts";
    };
  };

  config = mkIf cfg.enable {
    services.autofs = {
      enable = true;

      autoMaster = let
        sshFsLines =
          map (machine: "${machine}  -fstype=fuse,port=22,idmap=user,rw,allow_other,noatime :sshfs\\#tomas@${machine}\\:/")
          machines;
        sshFsMapConf = pkgs.writeText "sshfs.conf" (concatStringsSep "\n" sshFsLines);
        nfsConf = pkgs.writeText "nfs.conf" ''
          ${concatStringsSep "\n" (map (folder: ''
            silver-star-${folder} -rw,soft,intr,rsize=8192,wsize=8192 silver-star.local:/mnt/user/${folder}
          '') ["downloads" "data" "appdata" "backup" "games" "games_ssd" "domains" "isos"])}
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
