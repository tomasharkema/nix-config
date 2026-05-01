{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  bottles-removed = pkgs.bottles.override {removeWarningPopup = true;};
  nrf-custom = pkgs.nrfutil.withExtensions [
    "nrfutil-completion"
    "nrfutil-device"
    "nrfutil-trace"
    "nrfutil-toolchain-manager"
    "nrfutil-ble-sniffer"
    "nrfutil-sdk-manager"
    "nrfutil-nrf5sdk-tools"
    #       ble-sniffer        0.17.1   Bluetooth Low Energy (Bluetooth LE) sniffer for Nordic Semiconductor devices.
    # completion
    # device             2.17.1   Device discovery, programming, and operations such as erase, reset, and recovery.
    # nrf5sdk-tools      1.1.0    nRF5 SDK tools that were available in nRF Util 6
    #    dfu
    #    keys
    #    pkg
    #    settings
    #    zigbee
    # toolchain-manager  0.15.0   Manage and use toolchains for nRF Connect SDK
  ];

  pks = with pkgs; [
    # keep-sorted start
    _86box-with-roms
    angryipscanner
    antares
    arduino-ide
    bazaar
    beekeeper-studio
    bluebubbles
    bluetooth_battery
    # inputs.zephyr-nix.packages."${pkgs.stdenv.hostPlatform.system}".sdkFull
    # inputs.zephyr-nix.packages."${pkgs.stdenv.hostPlatform.system}".hosttools
    # bottles-removed
    bottles-removed
    boxbuddy
    brave
    brave-search-cli
    buttermanager
    cameractrls
    celestia
    chromium
    clipqr
    clutter
    code-nautilus
    coppwr
    crosspipe
    custom.actioneer
    custom.butler
    custom.denon-control
    custom.distrib-dl
    custom.gitpulsar
    custom.gtk-meshtastic-client
    custom.letters
    custom.manuals
    custom.netsleuth
    custom.one-ware
    custom.qefi-entry-manager
    custom.remarkable-cups
    custom.retro-adsb-radar
    # bitwarden-cli
    # bitwarden-desktop
    # bitwarden-menu
    custom.rgitui
    custom.rust-conn
    custom.toolblex
    custom.usbguard-gnome
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
    file-roller
    filezilla
    flamp
    flatpak-builder
    fldigi
    fllog
    font-manager
    fractal
    gdm-settings
    ghex
    glabels-qt
    gnome-boxes
    gnomecast
    go-chromecast
    gotop
    gparted-full
    gphoto2
    gphoto2fs
    grsync
    gt
    gtk-engine-murrine
    guvcview
    handbrake
    hopper
    httpie-desktop
    i2c-tools
    ida-free
    imsprog
    inputs.picoforge.packages."${pkgs.stdenv.hostPlatform.system}".default
    inspector
    intel-gpu-tools
    inxi
    ipmiview
    jetbrains-toolbox
    kdePackages.kdenlive
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
    neohtop
    netpeek
    noti
    nrf-command-line-tools
    nrf-custom
    nrf5-sdk
    nrfconnect
    nrfconnect-bluetooth-low-energy
    nvramtool
    onioncircuits
    onionshare-gui
    opendrop
    openloco
    openra
    openrct2
    openrisk
    # openrw
    openswitcher
    orbvis
    pavucontrol
    pdfarranger
    pika-backup
    piper
    platformio
    # plex-desktop
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
    # qradiolink
    rmview
    rpi-imager
    rpiboot
    rtfm
    saleae-logic-2
    satellite
    sdrpp
    segger-jlink
    segger-ozone
    serial-studio
    smuview
    solaar
    spi-tools
    spotify
    sql-studio
    sqlitebrowser
    sublime-merge
    sway-launcher-desktop
    synology-drive-client
    the-powder-toy
    thonny
    tpmmanager
    transmission-remote-gtk
    tremotesf
    turtle
    typesetter
    # cutter
    uefitool
    ulauncher
    usbview
    uvccapture
    uvcdynctrl
    vial
    vlc
    vsce
    vte-gtk4
    webcamize
    webcamoid
    wine-wayland
    wiremix
    wl-clipboard
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
    # keep-sorted end
  ];
  cfg = config.gui.desktop;
in {
  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = pks;
  };
}
