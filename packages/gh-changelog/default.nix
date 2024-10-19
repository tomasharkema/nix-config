{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:
buildGoModule rec {
  pname = "gh-changelog";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "chelnak";
    repo = "gh-changelog";
    rev = "v${version}";
    hash = "sha256-qlzccfOyCAbDLOYTKJ4dScDnq7oFcn4YHHMJk83EUMg=";
  };

  vendorHash = "sha256-T4caJLh/RTwPgPMM3BAyXEN8WTFtP0kZCeRVTtAKp0Y=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/chelnak/gh-changelog/cmd.version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "A gh cli extension that will make your changelogs";
    homepage = "https://github.com/chelnak/gh-changelog";
    changelog = "https://github.com/chelnak/gh-changelog/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "gh-changelog";
  };
}
