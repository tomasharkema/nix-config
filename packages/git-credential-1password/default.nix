{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "git-credential-1password";
  version = "1.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ethrgeist";
    repo = "git-credential-1password";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FkmhnU8w51LzBMIFd1385gAaTl9O5G2JuFtnsN2zWTo=";
  };

  vendorHash = null;

  ldflags = ["-s"];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A Git credential helper that utilizes the 1Password CLI to authenticate a Git over http(s) connection";
    homepage = "https://github.com/ethrgeist/git-credential-1password";
    changelog = "https://github.com/ethrgeist/git-credential-1password/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "git-credential-1password";
  };
})
