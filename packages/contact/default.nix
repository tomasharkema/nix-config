{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  meshtastic-py,
  tree,
}: let
  py = python3.withPackages (ps: with ps; [meshtastic-py]);
in
  python3.pkgs.buildPythonApplication rec {
    pname = "contact";
    version = "1.2.2";

    # pyproject = false;

    src = fetchFromGitHub {
      owner = "pdxlocations";
      repo = "contact";
      rev = "v${version}";
      hash = "sha256-Bs5JzeObVfCXBi8kca/Tjt8eA9A/iPLbC0ImAKco8ow=";
    };

    unpackPhase = ''
      tree .
      tree $src
      mkdir -p ./src/contact
      cp -a $src/. ./src/contact/
      tree .
      tree $src
    '';

    postPatch = ''
      ls -la
      pwd
      #mv * src/main/

      cp ${./setup.py} setup.py
      cp ${./pyproject.toml} pyproject.toml
      ls -la
    '';

    # postInstall = ''
    #   mkdir -p $out/bin
    #   cp -r . $out/bin
    # '';
    nativeBuildInputs = [tree];
    propagatedBuildInputs = [meshtastic-py];

    meta = {
      description = "";
      homepage = "https://github.com/pdxlocations/contact";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "contact";
      platforms = lib.platforms.all;
    };
  }
