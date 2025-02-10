{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  fontconfig,
  freetype,
  xz,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "binwalk";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "ReFirmLabs";
    repo = "binwalk";
    rev = "v${version}";
    hash = "sha256-em+jOnhCZH5EEJrhXTHmxiwpMcBr5oNU1+5IJ1H/oco=";
  };

  cargoHash = "sha256-JQZYRdidiSrjPfSKBFGNy3skFiaUPsMWCb+fnniaRAM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      bzip2
      fontconfig
      freetype
      xz
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.CoreText
    ];

  doCheck = false;

  meta = {
    description = "Firmware Analysis Tool";
    homepage = "https://github.com/ReFirmLabs/binwalk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "binwalk";
  };
}
