{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "ssm";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "elliot40404";
    repo = "ssm";
    rev = "v${version}";
    hash = "sha256-ZZVT9RvfFnf0j454OUgOF2xzhKFDZKRaq/QBgyt0UbM=";
  };

  vendorHash = null;
}
