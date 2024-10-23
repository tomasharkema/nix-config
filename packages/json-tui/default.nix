{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ftxui,
  pkg-config,
  extra-cmake-modules,
  ninja,
  jsoncpp,
}:
stdenv.mkDerivation rec {
  pname = "json-tui";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "json-tui";
    rev = "v${version}";
    hash = "sha256-Rgan+Pki4kOFf4BiNmJV4mf/rgyIGgUVP1BcFCKG25w=";
  };

  nativeBuildInputs = [
    ninja
    cmake
    ftxui
    pkg-config
    extra-cmake-modules
  ];

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_FTXUI=${ftxui}"
    "-DFETCHCONTENT_SOURCE_DIR_JSON=${jsoncpp}"
  ];

  meta = with lib; {
    description = "A JSON terminal UI made in C";
    homepage = "https://github.com/ArthurSonzogni/json-tui";
    changelog = "https://github.com/ArthurSonzogni/json-tui/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "json-tui";
    platforms = platforms.all;
  };
}
