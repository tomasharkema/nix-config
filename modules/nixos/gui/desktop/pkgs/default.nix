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
    # _86Box-with-roms
    _ipmiview
    android-tools
    bazaar
    bitwarden-cli
    bitwarden-desktop
    bitwarden-menu
    blueberry
    bluetooth_battery
    bottles
    boxbuddy
    buttermanager
    cameractrls
    celestia
    chromium
    clipqr
    clutter
    code-nautilus
    coppwr
    custom.actioneer
    custom.butler
    custom.denon-control
    custom.distrib-dl
    custom.gtk-meshtastic-client
    custom.letters
    custom.netsleuth
    custom.remarkable-cups
    custom.rust-conn
    # custom.retro-adsb-radar
    custom.spi-tools
    custom.toolblex
    custom.usbguard-gnome
    custom.webcamize
    # angryipscanner
    # caffeine-ng
    # custom.manuals
    # custom.qlogexplorer
    custom.wifiman
    darktable
    davinci-resolve
    ddrescue
    ddrescueview
    ddrutility
    degate
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
    easyeffects
    effitask
    esp-idf-full
    esptool
    f1viewer
    filezilla
    flamp
    fldigi
    fllog
    font-manager
    fractal
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
    gt
    gtk-engine-murrine
    guvcview
    # handbrake
    helvum
    httpie-desktop
    i2c-tools
    ida-free
    imsprog
    inspector
    intel-gpu-tools
    inxi
    jetbrains-toolbox
    # kdePackages.kdenlive
    kicad
    ktailctl
    labelle
    libGL
    libGLU
    libimobiledevice
    libratbag
    librepods
    libsmbios
    linssid
    meld
    mesa-demos
    mission-center
    mixxx
    nautilus
    nautilus-python
    netpeek
    noti
    nrf-command-line-tools
    nrf5-sdk
    nrfconnect
    nrfconnect-bluetooth-low-energy
    nrfutil
    nvramtool
    onioncircuits
    onionshare-gui
    opendrop
    openloco
    openra
    openrct2
    openrisk
    openrw
    openswitcher
    pavucontrol
    pdfarranger
    pika-backup
    piper
    platformio
    plex-desktop
    plexamp
    pods
    powerjoular
    powerstat
    powertop
    pwvucontrol
    python312Packages.pyclip
    qFlipper
    qdirstat
    qjournalctl
    qmk
    qmk_hid
    # antares
    qradiolink
    rmview
    rpi-imager
    rtfm
    saleae-logic-2
    satellite
    sdrpp
    segger-jlink
    segger-ozone
    serial-studio
    smuview
    solaar
    # solana-cli
    spotify
    sqlitebrowser
    sublime-merge
    sway-launcher-desktop
    synology-drive-client
    thonny
    tpmmanager
    transmission-remote-gtk
    tremotesf
    turtle
    typesetter
    ulauncher
    usbview
    uvccapture
    uvcdynctrl
    vial
    vlc
    vsce
    vte-gtk4
    webcamoid
    wine-wayland
    wiremix
    wl-clipboard
    wolfram-engine
    wsjtx
    xdg-utils
    xdgmenumaker
    xdiskusage
    xdotool
    xpipe
    xplanet
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
