{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gh-b";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "joaom00";
    repo = "gh-b";
    rev = "v${version}";
    hash = "sha256-7mgmgDqJZE2NqQ+dqK1e+kmsLXM4VARZI1akUWaSCPI=";
  };

  vendorHash = "sha256-Qq7denlGwBdMjhdno9uLKsu64SaGEFXH8zCplNivsIM=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "GitHub CLI extension to easily manage your branches";
    homepage = "https://github.com/joaom00/gh-b";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "gh-b";
  };
}
