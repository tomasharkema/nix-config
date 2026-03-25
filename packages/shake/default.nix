{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  help2man,
  attr,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shake";
  version = "0.31-unstable";

  src = fetchFromGitHub {
    owner = "unbrice";
    repo = "shake";
    rev = "8d7fe0596a2dc9b38aabd7640ffc29254ddd92fd"; # finalAttrs.version;
    sha256 = "sha256-vqC64pF0GK3jEzQlfsaZb66gqSIqPyS8io6ECVZDmdE=";
  };

  nativeBuildInputs = [
    cmake
    attr
    pkg-config
  ];

  buildInputs = [
    help2man
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "VERSION 3.14" "VERSION 3.5"
  '';
  meta = {
    description = "Shake is a defragmenter that runs in userspace";
    homepage = "https://github.com/unbrice/shake";
    changelog = "https://github.com/unbrice/shake/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "shake";
    platforms = lib.platforms.all;
  };
})
