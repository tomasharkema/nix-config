{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gperf,
  python3,
  glib,
  json_c,
  elfutils,
  rpm,
  copyPkgconfigItems,
  libxml2,
  autoconf,
  automake,
}:
stdenv.mkDerivation rec {
  pname = "satyr";
  version = "0.43";

  src = fetchFromGitHub {
    owner = "abrt";
    repo = "satyr";
    rev = version;
    hash = "sha256-MzXxhl0GncDejS4A2Uzz00llSA7V/udkFd20WUg71gU=";
  };

  enableParallelBuilding = true;

  outputs = ["out" "lib" "dev"];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    copyPkgconfigItems
    autoconf
    automake
  ];

  buildInputs = [
    gperf
    python3
    glib
    json_c
    elfutils
    rpm
    libxml2
  ];

  postPatch = ''
    sh gen-version
  '';

  configureFlags = [
    "--without-selinux"
  ];

  meta = with lib; {
    description = "Automatic problem management with anonymous reports";
    homepage = "https://github.com/abrt/satyr";
    changelog = "https://github.com/abrt/satyr/blob/${src.rev}/NEWS";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [];
    mainProgram = "satyr";
    platforms = platforms.all;
  };
}
