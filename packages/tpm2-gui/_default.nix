{
  lib,
  python3Packages,
  gobject-introspection,
  wrapGAppsHook,
  pkg-config,
  fetchFromGitHub,
  gtk3,
  tpm2-tss,
  pdm,
}:
with python3Packages;
# let
#   tss = tpm2-pytss.overridePythonAttrs (old: rec {
#     version = "1.2.0";
#     src = fetchPypi {
#       pname = "tpm2-pytss";
#       inherit version;
#       hash = "sha256-OgWWTjcj3Qd4dSaCwY+fuRQpLSFn4+9o11kPR9n8a54=";
#     };
#     patches = [];
#     doCheck = false;
#   });
# in
  buildPythonApplication rec {
    pname = "tpm2_gui";
    version = "0.0.2";
    # format = "pyproject";

    src = fetchFromGitHub {
      owner = "joholl";
      repo = "tpm2-gui";
      rev = "${version}";
      hash = "sha256-n30tVllDEcUT2ntUujgqqar/OeLJrzlRAu8mhc9tSFw=";
    };

    strictDeps = true;
    # doCheck = false;

    propagatedBuildInputs = [
      setuptools-scm
      tpm2-tss
      tpm2-pytss
      # tss
      pygobject3
      cryptography
      # pygtk
      # gobject-introspection
    ];

    nativeBuildInputs = [
      pdm-pep517
      pep517
      gobject-introspection
      pkg-config
      pkgconfig
      wrapGAppsHook
      wheel
      # tpm2-pytss
      pdm
    ];

    buildInputs = [gtk3 tpm2-tss];

    # pythonImportsCheck = [
    #   "tpm2_pytss"
    #   "tpm2_pytss.binding"
    # ];
    # postPatch = ''
    #   patchShebangs script
    # '';
  }
