{
  lib,
  appimageTools,
  fetchurl,
}: let
  pname = "tabby";
  version = "1.0.215";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.AppImage";
    hash = "sha256-7/p/kQYX8ydMOznl0ti0VgnU7c5jLp9IonI99zjeN+w=";
  };

  appimageContents = appimageTools.extractType1 {inherit name src;};
in
  appimageTools.wrapType1 {
    inherit name src;

    extraInstallCommands = ''
      mv $out/bin/${name} $out/bin/${pname}
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    # meta = {
    #   description = "Viewer for electronic invoices";
    #   homepage = "https://github.com/ZUGFeRD/quba-viewer";
    #   downloadPage = "https://github.com/ZUGFeRD/quba-viewer/releases";
    #   license = lib.licenses.asl20;
    #   sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    #   maintainers = with lib.maintainers; [onny];
    #   platforms = ["x86_64-linux"];
    # };
  }
# {
#   config,
#   lib,
#   stdenv,
#   dpkg,
#   autoPatchelfHook,
#   libz,
#   expat,
#   glib,
#   python3Packages,
#   fontconfig,
#   atk,
#   cups,
#   libpulseaudio,
#   xorg,
#   cudaPackages ? {},
#   addDriverRunpath,
#   libdrm,
#   mesa,
#   gtk3,
#   alsa-lib,
#   nss,
#   musl,
#   ffmpeg,
#   wrapGAppsHook3,
#   libcxx,
#   pkgs,
#   wayland,
# }:
# stdenv.mkDerivation rec {
#   pname = "tabby";
#   version = "1.0.125";
#   src = builtins.fetchurl {
#     url = "https://github.com/Eugeny/tabby/releases/download/v1.0.215/tabby-1.0.215-linux-x64.deb";
#     sha256 = "0l6638f6v49220ixhzpxms392ijhwkk42py8jzszhi1n0xnb39hy";
#   };
#   dontWrapGApps = true;
#   nativeBuildInputs = [
#     dpkg
#     autoPatchelfHook
#     python3Packages.wrapPython
#     mesa.drivers
#     wrapGAppsHook3
#     libz
#     fontconfig
#     expat
#     musl
#     libpulseaudio
#     xorg.libX11
#     glib
#     libdrm
#     atk
#     cups
#     gtk3
#     stdenv.cc.cc.lib
#     alsa-lib
#     nss
#     ffmpeg
#   ];
#   dontConfigure = true;
#   dontBuild = true;
#   libPath = lib.makeLibraryPath (with pkgs;
#     with pkgs.xorg; [
#       libcxx
#       systemd
#       libpulseaudio
#       libdrm
#       mesa
#       stdenv.cc.cc
#       alsa-lib
#       atk
#       at-spi2-atk
#       at-spi2-core
#       cairo
#       cups
#       dbus
#       expat
#       fontconfig
#       freetype
#       gdk-pixbuf
#       glib
#       gtk3
#       libglvnd
#       libnotify
#       libX11
#       libXcomposite
#       libunity
#       libuuid
#       libXcursor
#       libXdamage
#       libXext
#       libXfixes
#       libXi
#       libXrandr
#       libXrender
#       libXtst
#       nspr
#       libxcb
#       pango
#       libXScrnSaver
#       libappindicator-gtk3
#       libdbusmenu
#       wayland
#     ]);
#   installPhase = ''
#     runHook preInstall
#     mkdir -p $out/bin $out/share/${pname} $out/opt/Tabby
#     cp -a usr/share/* $out/share
#     cp -a opt/Tabby/* $out/opt/Tabby
#     patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
#       $out/opt/Tabby/tabby
#     wrapProgramShell $out/opt/Tabby/tabby \
#       "''${gappsWrapperArgs[@]}" \
#       --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
#       --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
#       --prefix LD_LIBRARY_PATH : ${libPath}:${lib.makeLibraryPath [addDriverRunpath.driverLink]}:$out/opt/Tabby
#     substituteInPlace $out/share/applications/tabby.desktop \
#       --replace-fail "/opt/Tabby" "$out/opt/Tabby"
#     ln -s $out/opt/Tabby/tabby $out/bin
#     runHook postInstall
#   '';
# }
# {
#   lib,
#   stdenv,
#   fetchFromGitHub,
#   callPackage,
#   python3,
#   sentry-cli,
#   fetchYarnDeps,
#   nodejs,
#   fixup-yarn-lock,
#   yarn,
#   git,
#   fetchgit,
# }:
# stdenv.mkDerivation rec {
#   name = "tabby";
#   version = "1.0.215";
#   src = fetchgit {
#     rev = "v${version}";
#     hash = "sha256-JLOVw2B3bTOcjE2qVId8pITqy0KgxegXLsFky6ggs3E=";
#     url = "https://github.com/Eugeny/tabby.git";
#     leaveDotGit = true;
#   };
#   offlineCache = fetchYarnDeps {
#     yarnLock = "${src}/yarn.lock";
#     hash = "sha256-Qklo8iX27lE6VTUAX1bwa9yBw/tMx+G+FB2MJUkt+7s=";
#   };
#   nativeBuildInputs = [
#     nodejs
#     fixup-yarn-lock
#     yarn
#     git
#   ];
#   buildInputs = [
#     sentry-cli
#   ];
#   configurePhase = ''
#     runHook preConfigure
#     export HOME=$(mktemp -d)
#     yarn config --offline set yarn-offline-mirror "$offlineCache"
#     fixup-yarn-lock yarn.lock
#     yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
#     patchShebangs node_modules
#     runHook postConfigure
#   '';
#   buildPhase = ''
#     runHook preBuild
#     yarn --offline build
#     runHook postBuild
#   '';
#   meta = with lib; {
#     description = "A terminal for a more modern age";
#     homepage = "https://github.com/Eugeny/tabby";
#     license = licenses.mit;
#     maintainers = with maintainers; [];
#     mainProgram = "tabby";
#     platforms = platforms.all;
#   };
# }

