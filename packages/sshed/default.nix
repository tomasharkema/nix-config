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
    hash = "sha256-y8IQzOGs78T44jLcNNjPlfopyptX3Mhv2LdawqS1T+U=";
  };

  vendorHash = "sha256-21Vh5Zaja5rx9RVCTFQquNvMNvaUlUV6kfhkIvXwbVw=";

  postInstall = ''
    cp $out/bin/cmd $out/bin/sshed
  '';
}
