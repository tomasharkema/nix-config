{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tailscale-tui";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "bilguun0203";
    repo = pname;
    rev = "db90a604ac40c6222947d6c6f97f481641b80d48";
    sha256 = "sha256-P1tu56DkwZTxavFRrNM/Wx1N86M5k/XQRfDrv+VK1uE=";
  };

  vendorHash = "sha256-w6agPfHGYL5DCe3GbgdFsojQ3GEAs37ZeNvy2nL/kq0=";
}
