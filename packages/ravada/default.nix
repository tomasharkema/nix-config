{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "ravada";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "UPC";
    repo = "ravada";
    rev = "v${version}";
    hash = "sha256-FVE5VZ2PAjfIGjnWhn2GYCUf6zapttrULBpT3VxMLq0=";
  };

  meta = {
    description = "Remote Virtual Desktops Manager";
    homepage = "https://github.com/UPC/ravada";
    changelog = "https://github.com/UPC/ravada/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "ravada";
    platforms = lib.platforms.all;
  };
}
