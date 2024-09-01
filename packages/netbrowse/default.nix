{
  rustPlatform,
  fetchCrate,
  xorg,
  libGL,
  makeWrapper,
  makeDesktopItem,
  fetchurl,
  copyDesktopItems,
}: let
  icon = fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Gnome-preferences-system-network.svg/1920px-Gnome-preferences-system-network.svg.png";
    hash = "sha256-Uvkq78H8k5p0E8dU37SknXzd4xb1nELNWMPUH90iLgM=";
  };
  desktopItemm = makeDesktopItem {
    desktopName = "Netbrowse";
    name = "Netbrowse";
    exec = "netbrowse";
    icon = icon;
    categories = ["System"];
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "netbrowse";
    version = "0.1.1";
    src = fetchCrate {
      inherit pname version;
      hash = "sha256-wUznGsKAZrd6Ut/XpCNIMS9XA0mS1ORVouIpD2nX1JE=";
    };

    cargoHash = "sha256-M7IK9++EY87cv8poa2qFc5iAvMYd2NmPrR8SfH+nqNk=";

    nativeBuildInput = [copyDesktopItems makeWrapper];

    buildInputs = [
      xorg.libxcb
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXi
      libGL
      makeWrapper
    ];

    # desktopItems = [ desktopItem ];
    desktopItem = desktopItemm;

    postInstall = ''
      wrapProgram $out/bin/netbrowse --prefix LD_LIBRARY_PATH : "${xorg.libX11.out}/lib:${xorg.libXcursor.out}/lib:${xorg.libXrandr.out}/lib:${xorg.libXi.out}/lib:${libGL}/lib"
    '';
  }
