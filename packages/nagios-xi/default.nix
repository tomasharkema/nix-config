{
  stdenv,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  zlib,
  webkitgtk,
  gitUpdater,
  rpm,
  cpio,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "nagios-xi";
  version = "2024R1.2.1-1";

  src = fetchzip {
    url = "https://repo.nagios.com/nagiosxi-offline/nagiosxi-${version}.el9.x86_64.tar.gz";
    sha256 = "sha256:18qyacwdmcn65f8ndw828qnqi4hki4gagissmkvra233biliam8k";
  };

  nativeBuildInputs = [autoPatchelfHook rpm cpio];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    rpm2cpio nagiosxi-${version}.el9.x86_64.rpm  | cpio -idmv

    ls -la
    sleep 1000
  '';
}
