{
  lib,
  buildGoModule,
  fetchFromGitHub,
  procps,
  makeWrapper,
}:
buildGoModule rec {
  pname = "mackerel-check-systemd";
  version = "0.0.1";

  src = ./systemd-status;

  # doCheck = false;

  vendorHash = "sha256-4wSYCRSEBieND8k0p7fmLGXHBrzy3hxTeTVkk/55K4Y=";

  ldflags = [
    "-s"
    "-w"
  ];

  # nativeBuildInputs = [
  #   makeWrapper
  # ];

  # buildInputs = [procps];

  # find "$out/bin" -type f -exec wrapProgram {} --prefix PATH : ${lib.makeBinPath [ procps ]} \;
  # postInstall = ''
  #   wrapProgram $out/bin/check-procs --prefix PATH : ${lib.makeBinPath [procps]}
  # '';

  meta = with lib; {
    description = "Check Plugins for monitoring written in golang";
    homepage = "https://github.com/mackerelio/go-check-plugins";
    changelog = "https://github.com/mackerelio/go-check-plugins/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "systemd-status";
  };
}
