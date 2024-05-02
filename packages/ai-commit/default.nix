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
  gcc,
  libgcc,
  libcxx,
  libcxxabi,
  llvmPackages,
  gitUpdater,
}:
buildNpmPackage rec {
  pname = "ai-commit";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "insulineru";
    repo = pname;
    rev = "76f3f9983bbd435cadf7c854f00f70f165122c59";
    hash = "sha256-pqcczObKkeC2sS0Y0XHBZM+oS4x4UUlr7pSutls7GzI=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "";
}
