{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mackerel-check-plugins";
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = "go-check-plugins";
    rev = "v${version}";
    hash = "sha256-x3g2MS6ik3DMm98MPEZjAheSuiQYrc0NXn6b1Yh+a5U=";
  };

  doCheck = false;

  vendorHash = "sha256-MzftScGmix89tFgA7usYZ4nXyf4htYhj0h+VMQUyOCc=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Check Plugins for monitoring written in golang";
    homepage = "https://github.com/mackerelio/go-check-plugins";
    changelog = "https://github.com/mackerelio/go-check-plugins/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "go-check-plugins";
  };
}
