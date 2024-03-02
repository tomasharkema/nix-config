{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tailscale-tui";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "bilguun0203";
    repo = pname;
    rev = "9be253f5a75829fbf64472a67dcccb9730fa9c69";
    sha256 = "sha256-j5azNUtsI6aNkg9tkpawLPxiwNBp/tP5V28VijtHrns=";
  };

  vendorHash = "sha256-r05aVSwIORiJtKvS8fJFUoYRMB5272M+G9YhobwA6c8=";
}
