{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  udev,
}:
buildGoModule rec {
  pname = "dev-notifier";
  version = "unstable-2025-04-01";

  src = fetchFromGitHub {
    owner = "tomasharkema";
    repo = "dev-notifier";
    rev = "main";
    hash = "sha256-xF45m/SF/UtoJhLlo3cOcV4V6FUojnNhCa6NccWRqBY=";
  };

  vendorHash = "sha256-vHp2hLSTzVrtu5zSPYnBTbr1n3XhsV9OyzeXT7VdPvc=";

  ldflags = ["-s" "-w"];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [udev];

  meta = {
    description = "";
    homepage = "https://github.com/tomasharkema/dev-notifier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "dev-notifier";
  };
}
