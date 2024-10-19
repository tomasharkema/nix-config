{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gh-milestone";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "valeriobelli";
    repo = "gh-milestone";
    rev = "v${version}";
    hash = "sha256-wEfTUKpcPUbDpT83yymeQmCZaynAmUStRFlLX+y0PqM=";
  };

  vendorHash = "sha256-SpI8DaghgkediYiwWKRqFZREJhGFlLl36V5q+ajtYh0=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "GitHub CLI extension for managing Milestones";
    homepage = "https://github.com/valeriobelli/gh-milestone";
    changelog = "https://github.com/valeriobelli/gh-milestone/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "gh-milestone";
  };
}
