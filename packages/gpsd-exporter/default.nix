{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gpsd-exporter";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "gpsd-exporter";
    rev = "v${version}";
    hash = "sha256-LdT+NIbjp6sjmVZxI8srU6jIvWTbZcaTtPlXUSwxuWg=";
  };

  vendorHash = "sha256-Sh1ezMMwoWjIQyquffud4upuZkukBLsVZAVdJyDWqrQ=";

  ldflags = ["-s" "-w"];

  meta = {
    description = "Export gpsd metrics to Prometheus";
    homepage = "https://github.com/natesales/gpsd-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "gpsd-exporter";
  };
}
