{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mkr";
  version = "0.58.0";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = "mkr";
    rev = "v${version}";
    hash = "sha256-saMYt7f4daQkpP/lsxfMVniDpJXJPQ+vIYoQdmeJWbc=";
  };

  vendorHash = "sha256-+VeF5MCQy1B508d9vQW7A/tKwJCAWcT6NDp9EGOSmow=";

  ldflags = ["-s" "-w"];

  doCheck = false;

  meta = with lib; {
    description = "Command Line Tool for Mackerel";
    homepage = "https://github.com/mackerelio/mkr";
    changelog = "https://github.com/mackerelio/mkr/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "mkr";
  };
}
