{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "xmmctl";
  version = "unstable-2021-12-21";

  src = fetchFromGitHub {
    owner = "mlukow";
    repo = "xmmctl";
    rev = "6afe12813d15d71ccc948ffc1d3fed4152ce8646";
    hash = "sha256-OSEAj7IiqipBgtr+bjlWs5Grl11gOqlyuCMg60YJR20=";
  };

  nativeBuildInputs = [pkg-config];

  buildInputs = [openssl];

  installPhase = ''
    runHook preInstall

    install -Dm755 xmmctl $out/bin/xmmctl

    runHook postInstall
  '';

  meta = with lib; {
    description = "A c rewrite of the python tool found in xmm7360-pci. Based on OpenBSD work";
    homepage = "https://github.com/mlukow/xmmctl";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "xmmctl";
    platforms = platforms.all;
  };
}
