{
  lib,
  stdenv,
  fetchFromGitHub,
  luacheck,
}:
stdenv.mkDerivation rec {
  pname = "xcodebuild-nvim";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "wojciech-kulik";
    repo = "xcodebuild.nvim";
    rev = "v${version}";
    hash = "sha256-LPf9MSdl7+4WVMH3t6slokO0xZ2Q8OBoJIlvvjj2QOU=";
  };

  buildInputs = [luacheck];

  meta = with lib; {
    description = "Neovim plugin to Build, Debug, and Test applications created for Apple devices (iOS, macOS, watchOS, etc";
    homepage = "https://github.com/wojciech-kulik/xcodebuild.nvim";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "xcodebuild-nvim";
    platforms = platforms.all;
  };
}
