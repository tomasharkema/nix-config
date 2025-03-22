{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation rec {
  pname = "partclone-utils";
  version = "unstable-2021-03-06";

  src = fetchFromGitHub {
    owner = "vasi";
    repo = "partclone-utils";
    rev = "44e9f521193ac69a30352d75346b86ce7dfa65c2";
    hash = "sha256-MF9a9Bo7QfPXckT7Q5nlfv1qmkmVkbvsHIZfhKSY+dM=";
  };

  nativeBuildInputs = [autoreconfHook];

  meta = {
    description = "Mount partclone images (PATCHES";
    homepage = "https://github.com/vasi/partclone-utils";
    changelog = "https://github.com/vasi/partclone-utils/blob/${src.rev}/ChangeLog";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "partclone-utils";
    platforms = lib.platforms.all;
  };
}
