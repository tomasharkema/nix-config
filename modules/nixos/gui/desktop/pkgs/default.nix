{
  pkgs,
  lib,
  config,
  ...
}: let
  pks = with pkgs; [
    # custom.wifiman
    wine-wayland
    openrct2
    openrw
    openra
    openrisk
    openloco
    opendrop
    openswitcher
    sway-launcher-desktop
    digital
    esptool
    esphome
    kicad
    platformio
    #  digikam
    dsview
    smuview
    digiham
    fllog
    flamp
    fldigi
    helvum
    custom.denon-control
    synology-drive-client
    ida-free
    segger-jlink
    custom.butler
    ddrescue
    ddrescueview
    ddrutility
    darktable
    custom.wsjtx
    sdrpp
    rpi-imager
    custom.netsleuth
    #handbrake
    thonny
    coppwr
    custom.gtk-meshtastic-client
    libwacom
    chromium
    noti
    ghex
    solaar
    solana-cli
    imsprog

    caffeine-ng
    gphoto2
    gphoto2fs
    # gphotos-sync
    blueberry
    custom.spi-tools
    qFlipper
    mtr-gui
    (lib.mkIf pkgs.stdenv.isx86_64 arduino-ide)

    ptyxis
    wl-clipboard
    python312Packages.pyclip
    onioncircuits
    onionshare-gui
    pods
    meld
    pika-backup
    vlc
    boxbuddy
    clutter
    dosbox-x
    effitask
    filezilla
    font-manager
    fractal
    doublecmd
    gamehub
    gnomecast
    go-chromecast
    gotop
    gparted
    grsync
    gtk-engine-murrine
    ktailctl
    libGL
    libGLU

    mission-center
    # nix-software-center
    pavucontrol
    powertop
    pwvucontrol
    qdirstat
    qjournalctl
    # rtfm
    spot
    sqlitebrowser
    # sublime-merge
    # sublime4
    transmission-remote-gtk
    tremotesf
    ulauncher
    usbview
    # ventoy-full
    vsce
    vte-gtk4
    xdg-utils
    xdgmenumaker
    xdiskusage
    xdotool
    yelp
    f1viewer
    zed-editor

    jetbrains-toolbox
    synology-drive-client

    _86Box-with-roms

    #handbrake
    # pkgs.custom.git-butler
    # pkgs.wolfram-engine
    spotify
    angryipscanner
    # custom.qlogexplorer
    discordo
    dmidecode
    gdm-settings
    (ipmiview.overrideAttrs (old: {
      src = pkgs.fetchurl {
        url = "https://www.supermicro.com/Bios/sw_download/960/IPMIView_2.23.0_build.250519_bundleJRE_Linux_x64.tar.gz";
        sha256 = "13d0figi3azajafnlfwc0amw3b00rmxyrmq60rixvwx4wx2h361j";
      };
      version = "2.23.0";
    }))
    libsmbios
    plex-desktop
    plexamp
    xpipe

    custom.usbguard-gnome
  ];
  cfg = config.gui.desktop;
in {
  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = pks;
  };
}
