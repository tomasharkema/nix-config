{
  lib,
  pdm,
  python310Packages,
  pkgs,
}:
with python310Packages;
  buildPythonApplication rec {
    pname = "tpm2_gui";
    version = "0.0.2";
    format = "pyproject";

    src = pkgs.fetchFromGitHub {
      owner = "joholl";
      repo = "tpm2-gui";
      rev = "${version}";
      hash = "sha256-n30tVllDEcUT2ntUujgqqar/OeLJrzlRAu8mhc9tSFw=";
    };
    doCheck = false;

    nativeBuildInputs = [
      cffi
      pkgconfig # this is the Python module
      pkgs.pkg-config # this is the actual pkg-config tool
      setuptools-scm
      tpm2-pytss
    ];

    buildInputs = [
      pkgs.pkg-config
      pkgs.tpm2-tss
      tpm2-pytss
    ];

    propagatedBuildInputs = [
      cffi
      asn1crypto
      cryptography
      pyyaml
      pygobject3
      tpm2-pytss
      wheel
      setuptools
    ];

    postPatch = ''
      patchShebangs script
    '';
  }
