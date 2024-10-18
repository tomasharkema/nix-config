{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "git-credential-1password";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ethrgeist";
    repo = "git-credential-1password";
    rev = "v${version}";
    hash = "sha256-pNZ6ZzD6rE/GgwM7gNRyVyrYlZetMFI/d9m4R2CRuNY=";
  };

  vendorHash = null;

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "A Git credential helper that utilizes the 1Password CLI to authenticate a Git over http(s) connection";
    homepage = "https://github.com/ethrgeist/git-credential-1password";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "git-credential-1password";
  };
}
