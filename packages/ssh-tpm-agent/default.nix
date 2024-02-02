{
  pkgs,
  lib,
  ...
}:
with pkgs;
  buildGoModule rec {
    pname = "ssh-tpm-agent";
    version = "0.2.0";
    vendorHash = "sha256-6asfdFDDiz1JUcHv5rGtL5wrjxBcHfRYs5WU/o1Nqts=";

    src = fetchFromGitHub {
      owner = "Foxboron";
      repo = "ssh-tpm-agent";
      rev = "v${version}";
      hash = "sha256-vc61BKCROW96Szd80BYhvI8NqmAb2WnSmOpmCHCEQSE=";
    };

    # nativeBuildInputs = [musl];

    CGO_ENABLED = 0;

    doCheck = false;
  }
