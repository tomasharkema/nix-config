{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "squashfs-tools-ng";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "AgentD";
    repo = "squashfs-tools-ng";
    rev = "v${version}";
    hash = "sha256-ccz8mw+Mv5RUDcrESeeYqMgeBQt+akYWDw9yyiW8U8c=";
  };

  meta = {
    description = "A new set of tools and libraries for working with SquashFS images";
    homepage = "https://github.com/AgentD/squashfs-tools-ng";
    changelog = "https://github.com/AgentD/squashfs-tools-ng/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "squashfs-tools-ng";
    platforms = lib.platforms.all;
  };
}
