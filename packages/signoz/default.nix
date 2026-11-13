{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "signoz";
  version = "0.149.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SigNoz";
    repo = "signoz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vznl2FBN1BFsih+T8M/WZiDQAMAS29ycG3N/cCXZkrs=";
  };

  vendorHash = "sha256-dwg9Kd3McNFj1JllkoMcRsELECYikKNs5GPTOlyWT+o=";

  ldflags = ["-s"];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "SigNoz is an open-source, OpenTelemetry-native observability platform for your team and their AI agents. Get logs, metrics, and traces in one tool with features like APM, distributed tracing, log management, infra monitoring, etc. Combined with SigNoz MCP and a native AI teammate (in SigNoz Cloud) it helps you build more resilient apps";
    homepage = "https://github.com/SigNoz/signoz";
    changelog = "https://github.com/SigNoz/signoz/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "signoz";
  };
})
