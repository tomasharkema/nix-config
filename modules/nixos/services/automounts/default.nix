{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  machines = inputs.self.servers;
in {
  config = {
    services.autofs = {
      enable = true;

      autoMaster = let
        lines =
          map (machine: "${machine}  -fstype=fuse,port=22,idmap=user,rw,allow_other,noatime :sshfs\\#tomas@${machine}\\:/")
          machines;
        mapConf = pkgs.writeText "servers" (lib.concatStringsSep "\n" lines);
      in ''
        /mnt/servers file:${mapConf} --timeout=30
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
