{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}: let
  py = python3.withPackages (ps: with ps; [meshtastic]);
in
  python3.pkgs.buildPythonApplication rec {
    pname = "contact";
    version = "1.3.14";

    # pyproject = false;

    src = fetchFromGitHub {
      owner = "pdxlocations";
      repo = "contact";
      rev = "${version}";
      hash = "sha256-gicZtjwN+E64FtfIITXOkme6wdkDB31Q1sG0Hw2upyM=";
    };

    # postInstall = ''
    #   mkdir -p $out/bin
    #   cp -r . $out/bin
    # '';
    nativeBuildInputs = [];
    #propagatedBuildInputs = [meshtastic-py];

    meta = {
      description = "";
      homepage = "https://github.com/pdxlocations/contact";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "contact";
      platforms = lib.platforms.all;
    };
  }
