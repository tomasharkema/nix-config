{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  autoreconfHook,
  pkg-config,
  python3,
  intltool,
  asciidoc,
  sphinx,
  xmlto,
  glib,
  gtk3,
  systemd,
  libxml2,
  libreport,
}:
stdenv.mkDerivation rec {
  pname = "abrt";
  version = "2.17.6";

  src = fetchFromGitHub {
    owner = "abrt";
    repo = "abrt";
    rev = version;
    hash = "sha256-F8KO7/wdmrkvZTuVO9UKd99fSXduthIeigl3ShTYaqI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gettext
    intltool
    # py
    # py.pkgs.sphinx
    python3
    python3.pkgs.pytest
    asciidoc
    xmlto
    sphinx
    glib
    gtk3
    systemd
    libxml2
    libreport
  ];

  configureFlags = [
    "PYTHON_SPHINX=${sphinx}/bin/sphinx"
    "PYTEST=${python3.pkgs.pytest}/bin/pytest"
  ];

  postPatch = ''
    sh gen-version
  '';

  meta = with lib; {
    description = "Automatic bug detection and reporting tool";
    homepage = "https://github.com/abrt/abrt";
    changelog = "https://github.com/abrt/abrt/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [];
    mainProgram = "abrt";
    platforms = platforms.all;
  };
}
