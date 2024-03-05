{
  buildNpmPackage,
  fetchFromGitHub,
  # libptytty,
  darwin,
  lib,
  stdenv,
  nodePackages,
  python3,
  pkg-config,
}:
buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.1-rc.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "${version}";
    hash = "sha256-cWSynWQaCK2Ru+s+MpKbd3SX3gWaEWgOzIACy2yHk9c=";
  };
  npmDepsHash = "sha256-sGGBKyyoLdK49ml1VACi8h9OMgLSE20w34n2B08OGLk=";

  postInstall = ''
    cp -r shell $out/share
  '';

  buildInputs = (
    if stdenv.isDarwin
    then [darwin.Libsystem nodePackages.node-gyp-build python3 pkg-config]
    else []
  );
}
