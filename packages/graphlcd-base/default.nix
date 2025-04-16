{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  freetype,
  pkg-config,
  wiringpi,
}:
stdenv.mkDerivation rec {
  pname = "graphlcd-base";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "M-Reimer";
    repo = "graphlcd-base";
    rev = version;
    hash = "sha256-euG30uj/ckVhQwfbADkFA1a6Woy0wnhp3+GtPxJJ8RA=";
  };

  postPatch = ''
    substituteInPlace Make.config \
      --replace-fail "#HAVE_DRIVER_SSD1306" "HAVE_DRIVER_SSD1306" \
      --replace-fail " /etc" " ${placeholder "out"}/etc"
  '';

  installFlags = ["PREFIX=${placeholder "out"}"];

  nativeBuildInputs = [pkg-config];
  buildInputs = [
    fontconfig
    freetype
    wiringpi
  ];

  meta = {
    description = "Graphlcd-base is a driver library that can be used to drive small graphical LCDs from a PC";
    homepage = "https://github.com/M-Reimer/graphlcd-base";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "graphlcd-base";
    platforms = lib.platforms.all;
  };
}
