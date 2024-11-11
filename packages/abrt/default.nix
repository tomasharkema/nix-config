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
  sphinx-autobuild,
}: let
  py = python3.withPackages (ps: [sphinx]);
in
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
      py
      py.pkgs.sphinx
      asciidoc
      xmlto
      sphinx
      sphinx-autobuild
    ];

    # autoreconfFlags = [ "--without--pythondoc" ];

    postPatch = ''
        pwd 
        ls

      sh gen-version'';

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
