{
  inputs,
  config,
  lib,
  fetchFromGitHub,
  pkgs,
  ...
}: let
  packageOverrides = pkgs.callPackage ./python-packages.nix {};
  python = pkgs.python3.override {inherit packageOverrides;};
  pythonWithPackages = python.withPackages (ps: [ps.requests]);
in
  pkgs.stdenv.mkDerivation {
    name = "github-backup";
    propagatedBuildInputs = [
      pythonWithPackages
    ];

    src = fetchFromGitHub {
      owner = "alichtman";
      repo = "shallow-backup";
      rev = "91a39409224b451b9175549f1c50f135b22af63d";
      hash = "sha256-If5Ax/IVQrIhhn7o4BFkmqhY1O2j0QA+WlnvYtOEXEs=";
    };

    # dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      echo "#!${pythonWithPackages}/bin/python" >> $out/bin/github-backup
      cat backup.py >> $out/bin/github-backup
      chmod 755 $out/bin/github-backup
    '';
  }
