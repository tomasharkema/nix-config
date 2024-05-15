{ rustPlatform, fetchCrate, xorg, libGL, makeWrapper, makeDesktopItem, fetchurl,
}:

let
  icon = fetchurl {
    url =
      "https://upload.wikimedia.org/wikipedia/commons/8/80/Gnome-preferences-system-network.svg";
    hash = "sha256-+MPq3I0F+YDPFfWd74B3pkpipy+BBbAqD+6g34Y1njg=";
  };
  desk = makeDesktopItem {

    desktopName = "Netbrowse";
    name = "Netbrowse";
    exec = "netbrowse";
    icon = icon;
    categories = [ "System" ];
  };

in rustPlatform.buildRustPackage rec {
  pname = "netbrowse";
  version = "0.1.1";
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wUznGsKAZrd6Ut/XpCNIMS9XA0mS1ORVouIpD2nX1JE=";
  };

  cargoSha256 = "sha256-M7IK9++EY87cv8poa2qFc5iAvMYd2NmPrR8SfH+nqNk=";

  buildInputs = [
    xorg.libxcb
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    libGL
    makeWrapper
  ];

  postInstall = ''
    # mkdir -p $out/share/applications
    cp -r ${desk} $out
    wrapProgram $out/bin/netbrowse --prefix LD_LIBRARY_PATH : "${xorg.libX11.out}/lib:${xorg.libXcursor.out}/lib:${xorg.libXrandr.out}/lib:${xorg.libXi.out}/lib:${libGL}/lib"
  '';
}
