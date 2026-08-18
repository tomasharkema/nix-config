{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "lsoff";
  version = "0.1.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yutat23";
    repo = "lsoff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZhckDheORnoKz2468jUu1J4bAvY9yA8opUFn84alguA=";
  };

  vendorHash = "sha256-IQJQwWWL7fRbfA+u92yv7oV5LYuhu8BW4DGTlHHwXs4=";

  ldflags = ["-s"];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "CLI / TUI that lists listening TCP/UDP ports";
    homepage = "https://github.com/yutat23/lsoff";
    changelog = "https://github.com/yutat23/lsoff/blob/${finalAttrs.src.rev}/CHANGELOG.ja.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "lsoff";
  };
})
