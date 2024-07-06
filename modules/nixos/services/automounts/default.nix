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
  config = mkIf false {
    services.autofs = {
      enable = true;

      autoMaster = let
        lines =
          map (machine: ''
          '')
          servers;
        mapConf = pkgs.writeText "auto" ''
          kernel    -ro,soft,intr       ftp.kernel.org:/pub/linux
          boot      -fstype=ext2        :/dev/hda1
          windoze   -fstype=smbfs       ://windoze/c
          removable -fstype=ext2        :/dev/hdd
          cd        -fstype=iso9660,ro  :/dev/hdc
          floppy    -fstype=auto        :/dev/fd0
          server    -rw,hard,intr       / -ro myserver.me.org:/ \
                                        /usr myserver.me.org:/usr \
                                        /home myserver.me.org:/home
        '';
      in ''
        /mnt/servers file:${mapConf}
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
