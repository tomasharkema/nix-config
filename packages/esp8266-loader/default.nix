{
  fetchFromGitHub,
  ghidra,
}:
ghidra.buildGhidraExtension {
  pname = "esp8266-loader";
  version = "0-unstable-2024-02-07";

  src = fetchFromGitHub {
    owner = "IridiumXOR";
    repo = "esp8266-loader";
    rev = "6229b8cb243e6c9d3cc87cac22cd2712f5db20c8";
    hash = "sha256-SM82Z+0BEn/9Ce0106PrJp8WYxuW5LMaK7rDtjIswko=";
  };

  patches = [./fixes.patch];
}
