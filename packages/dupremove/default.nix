{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  libuuid,
  sqlite,
}:
stdenv.mkDerivation rec {
  pname = "duperemove";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
    hash = "sha256-iMv80UKktYOhNfVA3mW6kKv8TwLZaP6MQt24t3Rchk4=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [glib libuuid sqlite];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Tools for deduping file systems";
    homepage = "https://github.com/markfasheh/duperemove";
    changelog = "https://github.com/markfasheh/duperemove/blob/${src.rev}/Changelog.md";
    license = with licenses; [bsd2 gpl2Only];
    maintainers = with maintainers; [];
    mainProgram = "duperemove";
    platforms = platforms.all;
  };
}
