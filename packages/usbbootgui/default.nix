{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  autoPatchelfHook,
  glib,
  gtk2,
  libusb1,
}:
stdenv.mkDerivation rec {
  pname = "usbbootgui";
  version = "unstable-2020-10-13";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbbootgui";
    rev = "1e9cc0f7539c7f94872a13187a97b5996c1487f4";
    hash = "sha256-Q3310vtBEUHWGN5Ff+hR9a+C7wDwTeZLP5WCF0EOZkU=";
  };
  nativeBuildInputs = [
    pkg-config
    # autoconf
    # automake
    autoreconfHook
    glib
    autoPatchelfHook
    gtk2
  ];
  buildInputs = [libusb1];
  meta = {
    description = "GUI for booting a Raspberry Pi device like Pi Zero or compute module as a device";
    homepage = "https://github.com/raspberrypi/usbbootgui";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "usbbootgui";
    platforms = lib.platforms.all;
  };
}
