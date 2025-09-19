{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "linux-wifi-hotspot";
  version = "4.7.2";

  src = fetchFromGitHub {
    owner = "lakinduakash";
    repo = "linux-wifi-hotspot";
    rev = "v${version}";
    hash = "sha256-+WHYWQ4EyAt+Kq0LHEgC7Kk5HpIqThz6W3PIdW8Wojk=";
  };

  meta = {
    description = "Feature-rich wifi hotspot creator for Linux which provides both GUI and command-line interface. It is also able to create a hotspot using the same wifi card which is connected to an AP already ( Similar to Windows 10";
    homepage = "https://github.com/lakinduakash/linux-wifi-hotspot";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [];
    mainProgram = "linux-wifi-hotspot";
    platforms = lib.platforms.all;
  };
}
