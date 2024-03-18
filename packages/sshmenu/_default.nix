#https://github.com/antonjah/ssh-menu
{
  python39,
  python39Packages,
  fetchPypi,
  fetchFromGitHub,
  pdm,
  fetchurl,
  fetchgit,
  fetchhg,
  pkgs,
}:
with python39;
with python39Packages; let
  packages = ps: ps.callPackage ./python-packages.nix {};

  python = python39.withPackages (python-pkgs: [
    (packages python-pkgs).bullet
  ]);
in
  python.pkgs.buildPythonPackage rec {
    pname = "sshmenu";
    version = "1.5.1";

    src = fetchFromGitHub {
      owner = "antonjah";
      repo = "ssh-menu";
      rev = "${version}";
      hash = "sha256-ag2IcIvfPS3fsL8rqdNbD7h7YsH8nBSfkByrrXex8Wc=";
    };

    # doCheck = false;

    nativeBuildInputs = [
      pip
      pdm
      pdm-pep517
    ];
  }
