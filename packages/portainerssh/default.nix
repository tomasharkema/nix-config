{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "portainerssh";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "devbranch-vadym";
    repo = "portainerssh";
    rev = "v${version}";
    hash = "sha256-7o3YDvAnjL86+yy5UkFiRs3GRD0XdSQX+J/kq+6gWZk=";
  };

  vendorHash = "sha256-iTNKCQ3vzhAqNaTEz1SOk5/c6WInfx+3QD6ZvxyjisE=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Native SSH-like shell client for Portainer containers, provided a powerful native terminal to manage your Docker containers";
    homepage = "https://github.com/devbranch-vadym/portainerssh";
    changelog = "https://github.com/devbranch-vadym/portainerssh/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "portainerssh";
  };
}
