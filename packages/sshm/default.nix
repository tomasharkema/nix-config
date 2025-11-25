{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "sshm";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "Gu1llaum-3";
    repo = "sshm";
    rev = "v${version}";
    hash = "sha256-0jEKBgA8NoQvR56+ssBh8y7YvVvOmBtivZB39/AHvwU=";
  };

  vendorHash = "sha256-aU/+bxcETs/Jq5FVAdiioyuc1AufvWeiqFQ7uo1cK1k=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Gu1llaum-3/sshm/cmd.AppVersion=${version}"
  ];

  doCheck = false;

  meta = {
    description = "SSHM is a beautiful command-line tool that transforms how you manage and connect to your SSH hosts. Built with Go and featuring an intuitive TUI interface, it makes SSH connection management effortless and enjoyable";
    homepage = "https://github.com/Gu1llaum-3/sshm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "sshm";
  };
}
