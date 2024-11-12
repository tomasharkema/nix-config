{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mkrg";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "mkrg";
    rev = "v${version}";
    hash = "sha256-ykc/AItgU+m/6ghBIanAr9DvNBmn5jW1Er5cpqwEmiQ=";
  };

  vendorHash = "sha256-YqsQTRNmLn+WkPueNFoX976oU80e8BCX+e3v4ca+Gbc=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Mackerel graph viewer in terminal";
    homepage = "https://github.com/itchyny/mkrg";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "mkrg";
  };
}
