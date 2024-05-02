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
    hash = "sha256-ZsEAE9EDJLREpKjHLbvqAUNM/y9eCH44g3D8NHYHiT4=";
  };
}
