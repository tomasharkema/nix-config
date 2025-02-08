{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt5,
  libusb1,
  pkg-config,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "ims-prog";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "bigbigmdm";
    repo = "IMSProg";
    rev = "v${version}";
    hash = "sha256-ivDK/ERW44RiNLgFZC7SG+sL2ap27cbzRkKQ4r+R7QE=";
  };

  enableParallelBuilding = true;

  # cmakeFlags = [
  #   "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  #   "-DUDEVDIR=${placeholder "out"}"
  # ];

  # cmakeFlags = [
  #   "-DCMAKE_INSTALL_PREFIX="
  #   # "-DCMAKE_INSTALL_DATAROOTDIR=${placeholder "out"}/share"
  #   # "-DCMAKE_INSTALL_BINDIR=${placeholder "out"}/bin"
  #   # "-DCMAKE_INSTALL_LIBDIR=${placeholder "out"}/lib"
  # ];

  installFlags = [
    #   "DESTDIR=$(out)"
    # "UDEVDIR=${placeholder "out"}/share/udev"
  ];

  buildInputs = [libusb1 qt5.full];

  nativeBuildInputs = [
    cmake
    ninja
    qt5.wrapQtAppsHook
    pkg-config
  ];

  preConfigure = ''
    substituteInPlace IMSProg_programmer/CMakeLists.txt \
      --replace "\''${UDEVDIR}" "$out/lib/udev"
  '';

  postInstall = ''

    for f in "$out/share/applications/*.desktop"; do
      substituteInPlace $f \
        --replace "/usr" "$out"
    done

  '';

  meta = {
    description = "IMSProg - software for CH341A-based programmers to work with I2C, SPI and MicroWire EEPROM/Flash chips";
    homepage = "https://github.com/bigbigmdm/IMSProg";
    changelog = "https://github.com/bigbigmdm/IMSProg/blob/${src.rev}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "ims-prog";
    platforms = lib.platforms.all;
  };
}
