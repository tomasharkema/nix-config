{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gh-token";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Link-";
    repo = "gh-token";
    rev = "v${version}";
    hash = "sha256-34r8VImZ+0dtlPd9eBPTFKRnZV9ClNFAurl350Z/4vE=";
  };

  vendorHash = "sha256-1rVYkMfc5zZXGtFK4fZF2lFFDRHX26jUuBAAuqCHvEY=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Manage installation access tokens for GitHub apps from your terminal";
    homepage = "https://github.com/Link-/gh-token";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "gh-token";
  };
}
