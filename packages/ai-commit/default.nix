{ buildNpmPackage, fetchFromGitHub,
# libptytty,
darwin, lib, stdenv, nodePackages, python3, pkg-config, gcc, libgcc, libcxx
, libcxxabi, llvmPackages, gitUpdater, unstableGitUpdater, }:
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

  npmDepsHash = "sha256-sZJM/n6T5uw8EO3txglh3VVS3jPhKF+wbbpDn2n1D+k=";
  dontNpmBuild = true;
  NODE_OPTIONS = "--openssl-legacy-provider";

  passthru.updateScript =
    unstableGitUpdater { url = "https://github.com/insulineru/ai-commit.git"; };
}
