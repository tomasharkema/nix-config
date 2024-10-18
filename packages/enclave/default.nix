{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "enclave";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "sangfansh";
    repo = "SGX101_sample_code";
    rev = "e2d20cdb54e064fb9b62c14d2a9347b964f59b58";
    hash = "sha256-OcIYDUlPO4nBJ+culdNKS7b/zzNYpgVNU9agONoJRqE=";
  };

  sourceRoot = "${src.name}/HelloEnclave/";
}
