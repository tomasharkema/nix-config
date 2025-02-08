{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "clamav-exporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "sergeymakinen";
    repo = "clamav_exporter";
    rev = "v${version}";
    hash = "sha256-DQu2xWZDik3G47W5pn1FMAIuHQug6tM1gnX/LObmbQo=";
  };

  vendorHash = "sha256-KhHcgT8v5HMtffgHsw5IuZJcSfy1uBjalVqfzcr/EBM=";

  ldflags = [
    "-s"
    "-X=github.com/prometheus/common/version.Version=${version}"
    "-X=github.com/prometheus/common/version.Revision=${src.rev}"
    "-X=github.com/prometheus/common/version.Branch=${src.rev}"
    # "-X=github.com/prometheus/common/version.BuildUser=envUser}@${envHostname}"
    # "-X=github.com/prometheus/common/version.BuildDate=time20060102150405}"
  ];

  meta = {
    description = "Export ClamAV daemon stats via a TCP socket to Prometheus";
    homepage = "https://github.com/sergeymakinen/clamav_exporter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [];
    mainProgram = "clamav-exporter";
  };
}
