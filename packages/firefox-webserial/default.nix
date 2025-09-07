{
  lib,
  stdenv,
  fetchFromGitHub,
  platformio,
}:
stdenv.mkDerivation rec {
  pname = "firefox-webserial";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "kuba2k2";
    repo = "firefox-webserial";
    rev = "v${version}";
    hash = "sha256-fueWxSOyPTTxJ+60jvSN8vY5F8DHdm2V8xXnFdNLAnY=";
  };

  nativeBuildInputs = [platformio];

  buildPhase = ''
    cd native && platformio run -e linux_x86_64

  '';

  meta = {
    description = "WebSerial API Polyfill for Mozilla Firefox browser";
    homepage = "https://github.com/kuba2k2/firefox-webserial";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "firefox-webserial";
    platforms = lib.platforms.all;
  };
}
