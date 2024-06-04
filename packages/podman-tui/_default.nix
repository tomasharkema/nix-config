{ fetchFromGitHub, pkg-config, buildGoModule, btrfs-progs, gpgme, lvm2, }:
buildGoModule rec {
  pname = "podman-tui";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    rev = "v${version}";
    hash = "sha256-nPSUpGLSuIZMzgvmZtCZ3nqT5b1+0VkCmzPnUMLYkss=";
  };

  vendorHash = null;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ btrfs-progs gpgme lvm2 ];
}
