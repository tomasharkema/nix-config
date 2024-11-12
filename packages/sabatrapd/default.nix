{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "sabatrapd";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "yseto";
    repo = "sabatrapd";
    rev = "v${version}";
    hash = "sha256-yra6PLVW2DpWbwGCv1fHheOiqlreyaAFIGphhotcjMo=";
  };

  vendorHash = "sha256-k29AmGLwK3wAs+f4MQ1vgO5y1Q99re2M2S9iNkfbTL8=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Sabatrapd is the SNMP Trap handler for Mackerel";
    homepage = "https://github.com/yseto/sabatrapd";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "sabatrapd";
  };
}
