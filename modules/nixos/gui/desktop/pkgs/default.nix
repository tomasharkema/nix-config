{
  pkgs,
  lib,
  config,
  ...
}: let
  _ipmiview = pkgs.ipmiview.overrideAttrs (old: {
    src = pkgs.fetchurl {
      url = "https://www.supermicro.com/Bios/sw_download/960/IPMIView_2.23.0_build.250519_bundleJRE_Linux_x64.tar.gz";
      sha256 = "13d0figi3azajafnlfwc0amw3b00rmxyrmq60rixvwx4wx2h361j";
    };
    version = "2.23.0";
  });

  pks = with pkgs; [
    # keep-sorted start
    (lib.mkIf pkgs.stdenv.isx86_64 arduino-ide)
    _86Box-with-roms
    _ipmiview
    antares
    bazaar
    bitwarden-cli
    bitwarden-desktop
    bitwarden-menu
    blueberry
    boxbuddy
    chromium
    clutter
    coppwr
    custom.actioneer
    custom.butler
    custom.denon-control
    custom.gtk-meshtastic-client
    custom.letters
    custom.librepods
    custom.netsleuth
    custom.remarkable-cups
    custom.retro-adsb-radar
    custom.spi-tools
    custom.usbguard-gnome
    custom.webcamize
    # angryipscanner
    # caffeine-ng
    # custom.manuals
    # custom.qlogexplorer
    custom.wifiman
    custom.wsjtx
    darktable
    davinci-resolve
    ddrescue
    ddrescueview
    ddrutility
    digiham
    digikam
    digital
    discordo
    distroshelf
    dmenu
    dmidecode
    dosbox-x
    doublecmd
    dsview
    effitask
    esptool
    f1viewer
    filezilla
    flamp
    fldigi
    fllog
    font-manager
    gdm-settings
    ghex
    glabels-qt
    gnomecast
    go-chromecast
    gotop
    gparted
    gphoto2
    gphoto2fs
    grsync
    gtk-engine-murrine
    handbrake
    helvum
    httpie-desktop
    ida-free
    imsprog
    inspector
    jetbrains-toolbox
    # fractal
    # gamehub
    # gphotos-sync
    # nix-software-center
    # openloco
    # pkgs.custom.git-butler
    # pkgs.wolfram-engine
    # rtfm
    # solana-cli
    # sublime-merge
    # sublime4
    # ulauncher
    # ventoy-full
    kdePackages.kdenlive
    kicad
    ktailctl
    labelle
    libGL
    libGLU
    libsmbios
    meld
    mission-center
    mixxx
    netpeek
    noti
    nrf-command-line-tools
    nrf5-sdk
    nrfconnect
    nrfconnect-bluetooth-low-energy
    nrfutil
    onioncircuits
    onionshare-gui
    opendrop
    openra
    openrct2
    openrisk
    openrw
    openswitcher
    pavucontrol
    pdfarranger
    pika-backup
    platformio
    plex-desktop
    plexamp
    pods
    powertop
    pwvucontrol
    python312Packages.pyclip
    qFlipper
    qdirstat
    qjournalctl
    rmview
    rpi-imager
    saleae-logic-2
    satellite
    sdrpp
    segger-jlink
    segger-ozone
    serial-studio
    smuview
    solaar
    spotify
    sqlitebrowser
    sway-launcher-desktop
    synology-drive-client
    thonny
    tpmmanager
    transmission-remote-gtk
    tremotesf
    typesetter
    usbview
    vlc
    vsce
    vte-gtk4
    wine-wayland
    wl-clipboard
    xdg-utils
    xdgmenumaker
    xdiskusage
    xdotool
    xpipe
    yelp
    zed-editor
    zenmap
    zotero
    # keep-sorted end
  ];
  cfg = config.gui.desktop;
in {
  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = pks;
  };
}
