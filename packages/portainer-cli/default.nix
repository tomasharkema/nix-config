{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "portainer-cli";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "x1nchen";
    repo = "portainer-cli";
    rev = "v${version}";
    hash = "sha256-kgUkwg980XkcCTVUNv45L9imlBWMYRW5r3NnzZhzT5g=";
  };

  vendorHash = "sha256-deQTQMZ0tl/NMPN0h4JTX5LcjLXONLSdjCKe38L+NCU=";

  ldflags = [
    "-X=github.com/x1nchen/portainer-cli/cmd.Repo=https://github.com/x1nchen/portainer-cli" # ${gitUrl}"
    "-X=github.com/x1nchen/portainer-cli/cmd.Branch=${src.rev}"
    "-X=github.com/x1nchen/portainer-cli/cmd.Commit=${src.rev}"
    "-X=github.com/x1nchen/portainer-cli/cmd.Version=${version}"
  ];

  doCheck = false;
  meta = with lib; {
    description = "A cli tool to interacte portainer server";
    homepage = "https://github.com/x1nchen/portainer-cli";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "portainer-cli";
  };
}
