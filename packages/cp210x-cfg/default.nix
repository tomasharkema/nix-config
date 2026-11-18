{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  libusb1,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cp210x-cfg";
  version = "0-unstable-2017-01-05";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "DiUS";
    repo = "cp210x-cfg";
    rev = "424deb715e6293381d16a811905de7e530bf51d2";
    hash = "sha256-AIBAdt5TwlytuMns3drFMAHRdbcILyiRF2SlFBNjkMo=";
  };

  passthru.updateScript = nix-update-script {};

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  installPhase = ''
    runHook preInstall
    echo "To configure VeriFone dongle: ./cp210x-cfg -m 10C4:EA60 -N \"tomas CP2102 UART Bridge\""
    install -D cp210x-cfg $out/bin/cp210x-cfg

    runHook postInstall
  '';

  meta = {
    description = "CLI utility for programming CP210x USB<->UART bridges";
    homepage = "https://github.com/DiUS/cp210x-cfg";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "cp210x-cfg";
    platforms = lib.platforms.all;
  };
})
