{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libxml2,
  perl,
  python3,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "libsmbios";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "dell";
    repo = "libsmbios";
    rev = "v${version}";
    hash = "sha256-UahCH6D5oINkiHscjll2FHb/K63BE4QyESKt7ZvnPE8=";
  };

  nativeBuildInputs = [autoreconfHook pkg-config autoPatchelfHook];

  buildInputs = [libxml2 perl python3];

  meta = with lib; {
    description = "Library for interacting with Dell SMBIOS tables";
    homepage = "https://github.com/dell/libsmbios";
    license = licenses.osl21;
    maintainers = with maintainers; [];
    mainProgram = "libsmbios";
    platforms = platforms.all;
  };
}
