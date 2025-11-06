{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tabouli";
  version = "unstable-2022-01-14";

  src = fetchFromGitHub {
    owner = "Ovyl";
    repo = "tabouli";
    rev = "f323a0fdbd5c6e56ecb2e70fda3424f648663274";
    hash = "sha256-6SvZl5M3z6jCjrMoOziRnWqFStf9Kyb4cd6u844CnTQ=";
  };

  vendorHash = "sha256-sXoGdSZirYzEafvplpbrFN4POgTl+7zuExWADbfNqlY=";

  ldflags = ["-s" "-w"];

  meta = {
    description = "TUI for sending CLI commands to your firmware and devices";
    homepage = "https://github.com/Ovyl/tabouli";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "tabouli";
  };
}
