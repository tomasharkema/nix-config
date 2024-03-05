{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "sshed";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trntv";
    repo = "sshed";
    rev = "${version}";
    hash = "sha256-YCAySFNN3bP0wVUHtqJ94YjjTujZx2VPFTFI25CZLg0=";
  };

  vendorHash = "sha256-21Vh5Zaja5rx9RVCTFQquNvMNvaUlUV6kfhkIvXwbVw=";

  postInstall = ''
    mv $out/bin/cmd $out/bin/sshed
  '';
}
