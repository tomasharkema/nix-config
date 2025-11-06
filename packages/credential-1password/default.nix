{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "credential-1password";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "tlowerison";
    repo = "credential-1password";
    rev = "v${version}";
    hash = "sha256-06be5nueB6frDBqBKOJDsKaEYHDy4twdDru7ihMU8/c=";
  };

  vendorHash = "sha256-XjmqyCZKh1GbbKyVZrrHWBuVfAEOu91r5rNH5YTh07E=";

  ldflags = ["-s" "-w"];

  meta = {
    description = "1Password credential helper for git + docker";
    homepage = "https://github.com/tlowerison/credential-1password";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "credential-1password";
  };
}
