{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  zlib,
  webkitgtk,
}: let
  shortVersion = "0.11.3";
  build = "838";
  fullVersion = "${shortVersion}-${build}";
  fullArch =
    if stdenv.isx86_64
    then "x86_64"
    else "aarch64";
  arch =
    if stdenv.isx86_64
    then "amd64"
    else "aarch64";
in
  stdenv.mkDerivation rec {
    pname = "git-butler";
    version = fullVersion;

    src = fetchurl {
      url = "https://releases.gitbutler.com/releases/release/${fullVersion}/linux/${fullArch}/git-butler_${shortVersion}_${arch}.deb";
      hash = "sha256-GwyW5t2LslC3KoAvcngrec3qscsZaLWH5CyjI9nrZoo=";
    };

    # https://releases.gitbutler.com/releases/release/0.11.3-838/linux/x86_64/git-butler_0.11.3_amd64.deb

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
    ];

    buildInputs = [
      stdenv.cc.cc.lib
      zlib
      webkitgtk
    ];

    dontConfigure = true;

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/${pname}

      cp -a usr/share/* $out/share
      cp -a usr/bin/* $out/bin

      wrapProgram $out/bin/${pname}

      # substituteInPlace $out/share/applications/balena-etcher.desktop \
      #   --replace /opt/balenaEtcher/balena-etcher ${pname}

      runHook postInstall
    '';
  }
# {
#   appimageTools,
#   fetchzip,
#   fetchurl,
#   lib,
#   stdenv,
# }: let
#   shortVersion = "0.11.1";
#   build = "814";
#   fullVersion = "${shortVersion}-${build}";
#   fullArch =
#     if stdenv.isx86_64
#     then "x86_64"
#     else "aarch64";
#   arch =
#     if stdenv.isx86_64
#     then "amd64"
#     else "aarch64";
# in
#   appimageTools.wrapType2 rec {
#     pname = "git-butler";
#     version = fullVersion;
#     src = fetchurl {
#       url = "https://releases.gitbutler.com/releases/release/${fullVersion}/linux/${fullArch}/git-butler_${shortVersion}_${arch}.AppImage";
#       hash = "sha256-N/6aaB7RWCjF0jIMKR6ymvm6Md9o+sRB8cetPxEBUAo=";
#     };
#     extraPkgs = pkgs: with pkgs; [libthai];
#     extraInstallCommands = let
#       contents = appimageTools.extractType2 {inherit pname version src;};
#     in ''
#       mkdir -p "$out/share/applications"
#       cp -r ${contents}/usr/share/* "$out/share"
#       ln -fns "$out/bin/${pname}-${version}" "$out/bin/${pname}"
#     '';
#   }

