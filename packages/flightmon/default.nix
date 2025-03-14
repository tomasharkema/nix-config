{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "flightmon";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "mik3y";
    repo = "flightmon";
    rev = "v${version}";
    hash = "sha256-Z2l4RRKH1agMbhNzpP4qdSG5alellBq/vfnU1g6ffTs=";
  };

  vendorHash = "sha256-THPVmMUgTIBxbCB+lIHhPsfNuhHDGe5juglL1pafrgI=";

  ldflags = ["-s" "-w"];

  meta = {
    description = "Simple command-line \"GUI\" for showing current dump1090/readsb data";
    homepage = "https://github.com/mik3y/flightmon";
    changelog = "https://github.com/mik3y/flightmon/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "flightmon";
  };
}
