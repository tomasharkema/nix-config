# https://github.com/containers/podman-tui
{
  fetchFromGitHub,
  # stdenv,
  # pkg-config,
  buildGoModule,
  # btrfs,
}:
buildGoModule
rec {
  pname = "podman-tui";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    rev = "v${version}";
    hash = "sha256-QUHwLoNIjJBhIRPskOrPHwd8kwVUyXVNGRLNT/zGZ+A=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    # pkg-config
  ];
  buildInputs = [
    # btrfs
  ];
}
