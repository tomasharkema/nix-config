{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  makeWrapper,
  autoreconfHook,
  pkg-config,
  copyPkgconfigItems,
  libxslt,
  docbook_xsl,
  docbook_xml_dtd_45,
  intltool,
  doxygen,
  python3,
  wrapGAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "faf";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "abrt";
    repo = "faf";
    rev = version;
    hash = "sha256-ASqfq+pFM8A9CxvLdH2jaH+v9yhJRQGUZ2ipRmLNG30=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    autoreconfHook
    pkg-config
    copyPkgconfigItems
    libxslt
    docbook_xsl
    docbook_xml_dtd_45
    intltool
    doxygen
    python3.pkgs.wrapPython
    python3.pkgs.setuptools
    wrapGAppsHook
  ];

  meta = with lib; {
    description = "Platform for collection and analysis of packages and package crashes";
    homepage = "https://github.com/abrt/faf";
    changelog = "https://github.com/abrt/faf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "faf";
    platforms = platforms.all;
  };
}
