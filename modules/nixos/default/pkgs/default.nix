{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  ffmpegEdited = (
    (pkgs.ffmpeg-full.override {withUnfree = true;}).overrideAttrs (_: {
      doCheck = false;
    })
  );
in {
  config = {
    environment.systemPackages =
      (with pkgs; [
        # keep-sorted start
        agenix-rekey
        aide
        apt-dater
        archivemount
        bandwhich
        bash
        bashmount
        bat-extras.batdiff
        bat-extras.batman
        bat-extras.batpipe
        bat-extras.batwatch
        batmon
        binwalk
        bmc-tools
        bmon
        bridge-utils
        caligula
        castnow
        catt
        ccrypt
        chunkfs
        cksfv
        clang-tools
        clex
        cmake
        colorized-logs
        compose2nix
        compsize
        config.boot.kernelPackages.iio-utils
        config.virtualisation.incus.package.client
        cryptsetup # needed for dm-crypt volumes
        csa
        ctop
        curl
        curlftpfs
        # apfs-fuse
        # apfsprogs
        # bat-extras.batgrep
        # fancy-motd
        # jupyter
        # lz4
        # mkchromecast
        # nix-switcher # : needs github auth
        custom.discovery-rs
        custom.flightmon
        custom.menu
        custom.meshtui
        custom.partclone-utils
        custom.radar
        custom.sgrep
        custom.ssh-proxy-agent
        custom.sshm
        custom.ssm
        custom.swiftly
        custom.tailscale-tui
        custom.zide
        # rmfuse
        cutecom
        dblab
        ddrescue
        devcontainer
        devtodo
        dfrs
        distrobox
        distrobox-tui
        dry
        duc
        dump1090-fa
        dumphfdl
        dumpvdl2
        efibootmgr
        efivar
        ethtool
        fcast-receiver
        ffmpegEdited
        # freeipmi
        fresh-editor
        ftop
        fuse
        fuse3
        gdb
        gdbgui
        gdu
        gensio
        ghostty
        git
        glog
        glogg
        gnumake
        gnupg
        gpio-utils
        gpsd
        gptfdisk
        havn
        hdparm
        hextazy
        htmlq
        hueadm
        hw-probe
        i2c-tools
        ifuse
        imv
        inputs.neix.packages.${pkgs.system}.default
        ipcalc
        iperf
        iperf3
        # ipmitool
        # ipmiutil
        iptraf-ng
        isd
        jnettop
        kitty.terminfo
        kmon
        lazydocker
        lazyhetzner
        lazyworktree
        ldapdomaindump
        libftdi
        libftdi1
        libgcc.lib
        libgpiod
        libheif
        libnotify
        libsecret
        libusb1
        libuuid
        lm_sensors
        lnav
        lrzsz
        lshw
        mbuffer
        mlt
        more
        mpremote
        mpv
        ms-sys # for writing Microsoft boot sectors / MBRs
        ncdu
        net-tools
        nethogs
        netop
        netproc
        netscanner
        networkmanagerapplet
        nfs-utils
        nil
        ninja
        nix-alien
        nix-btm
        nix-check-deps
        nix-playground
        nix-search-cli
        nix-search-tv
        nix-top
        nixd
        nixos-anywhere
        nixos-facter
        nmap
        nmon
        ntfs3g
        ntfy
        ntfy-sh
        nvchecker
        nvme-cli
        nyaa
        onionshare
        # openipmi
        # openldap
        openocd
        openseachest
        opensoundmeter
        openssl
        openssl.out
        opkssh
        optnix
        # oterm
        p7zip
        pamix
        pamixer
        parted
        patchutils
        pciutils
        picotool
        pigz
        piratebay
        pkgs.custom.nix-helpers
        play
        ponymix
        poptop
        pps-tools
        psmisc
        pulsemixer
        pv
        pwgen
        python3Packages.pip
        python3Packages.pyftdi
        python3Packages.uv
        radare2
        redfishtool
        regname
        rsbkb
        rtl-sdr
        rtop
        s-tui
        screen
        sdparm
        ser2net
        sigrok-cli
        silenthound
        smartmontools
        socat
        socklog
        squashfs-tools-ng
        squashfsTools
        squashfuse
        ssh-import-id
        ssh-tools
        sshed
        sshfs
        sshfs-fuse
        sshportal
        starship
        strace
        subnetcalc
        swapview
        sysstat
        systemctl-tui
        systemd-language-server
        systemd-manager-tui
        systeroid
        sysz
        tailspin
        tcpdump
        tcptrack
        termshark
        testdisk # useful for repairing boot problems
        tio
        tiptop
        tparted
        tpm-tools
        tracexec
        tran
        treecat
        tshark
        ttmkfdir
        ttop
        tydra
        unzip
        update-nix-fetchgit
        updatecli
        urjtag
        usbredir
        usbutils
        usermount
        uv
        uxplay
        viddy
        vim
        watchlog
        wavemon
        waypipe
        websocat
        wget
        whatfiles
        wifitui
        wikiman
        witr
        wmctrl
        wol
        wtfutil
        xterm
        xwayland-satellite
        xxd
        zathura
        zip
        zstd
        # keep-sorted end
      ])
      ++ (lib.optionals pkgs.stdenv.isx86_64 (
        with pkgs; [
          # keep-sorted start
          cmospwd
          dmidecode
          fwupd
          fwupd-efi
          gnutls
          inteltool
          intentrace
          # ipmicfg
          libguestfs-with-appliance
          libsmbios
          meshtastic
          micropython
          refind
          spectre-meltdown-checker
          uefisettings
          # keep-sorted end
        ]
      ));
  };
}
