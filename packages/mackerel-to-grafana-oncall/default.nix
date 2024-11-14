{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mackerel-to-grafana-oncall";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "fujiwara";
    repo = "mackerel-to-grafana-oncall";
    rev = "v${version}";
    hash = "sha256-gP9Mj+m0FFswW0OHcQesQdicIZo0RA7g1DNVMAkfXmA=";
  };

  vendorHash = "sha256-NwaMkdn7rSIxrX/smLFXzbyw/HhYeHY+7kzRHhXy+cA=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=v${version}"
  ];

  meta = with lib; {
    description = "A proxy of Mackerel alert webhook to Grafana OnCall Formatted Webhook";
    homepage = "https://github.com/fujiwara/mackerel-to-grafana-oncall";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "mackerel-to-grafana-oncall";
  };
}
