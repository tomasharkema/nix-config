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
  version = "0.0.1-rc.10";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "${version}";
    hash = "sha256-TuZZaa0ie7Y2Wp6P4qFeQeAiXQ9quVYpiXjOEIadi7w=";
  };

  npmDepsHash = "sha256-mPhpDysr/8Ic31s1CBBfx0hBD+vw5yE5vnXKm/N9ITk=";

  postInstall = ''
    cp -r shell $out/share
  '';

  buildInputs = (
    if stdenv.isDarwin
    then [darwin.Libsystem nodePackages.node-gyp-build python3 pkg-config]
    else []
  );
}
