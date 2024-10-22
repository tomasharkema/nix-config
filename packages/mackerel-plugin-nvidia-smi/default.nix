{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mackerel-plugin-nvidia-smi";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = "mackerel-plugin-nvidia-smi";
    rev = "v${version}";
    hash = "sha256-P7r4gmEG0g/ynoYTXHQhvgA69c0REf1KKbkJ1h//SDI=";
  };

  vendorHash = "sha256-7+l/hKi0ynWgB56blXGSDI29hOrg8XilBbcW1bnFuAg=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/mackerelio/mackerel-plugin-nvidia-smi";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "mackerel-plugin-nvidia-smi";
  };
}
