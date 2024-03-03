{
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oFXLxWS2G+CkG0yuJLkA34SqoGGcXU/eZmFMRYw+Gzo=";
  };

  cargoSha256 = "sha256-MKxeRQupgAxA2ui8qSK8BvhxqqgjJarD8pY9wmk8MvA=";
}
