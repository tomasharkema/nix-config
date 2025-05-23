{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  zlib,
  webkitgtk,
  gitUpdater,
}: let
  shortVersion = "0.12.2";
  build = "980";
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
      sha256 = "sha256-su0YD/LR0YVckI0LwzyFlgwBvhYn83nCVQu07nWJ00c=";
    };

    #     passthru.updateScript = gitUpdater {
    #   url = "https://github.com/grpc/grpc-node.git";
    #   rev-prefix = "grpc-tools@";
    # };

    nativeBuildInputs = [autoPatchelfHook dpkg makeWrapper];

    buildInputs = [stdenv.cc.cc.lib zlib webkitgtk];

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
