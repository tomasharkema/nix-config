{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "sendtelegram";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "gstracquadanio";
    repo = "sendtelegram";
    rev = "v${version}";
    sha256 = "sha256-PU+okVkvvyPY7iN/L2hj995sY7VezjveZ7gBwr+fis8=";
  };

  vendorHash = null;
  patches = [./mod.patch];
}
