{
  buildGoModule,
  fetchFromGitHub,
  lib,
  pkgs,
}:
buildGoModule rec {
  pname = "go-nixos-menu";
  version = "0.0.1";

  # buildInputs = [pkgs.go];
  CGO_ENABLED = 0;

  vendorHash = "sha256-jMkAckDFAC4ISq1AGnVViC+j9EujFuz0X10WNB9vzZc=";

  src = fetchFromGitHub {
    owner = "tomasharkema";
    repo = "go-nixos-menu";
    rev = "b17f3e36317099dd9c820c91238ad16d6b59910e";
    hash = "sha256-eKTQNr51HzOJ//JK065KKR0ZgbT6gTXdmGiPd3trUQ4=";
  };

  meta = with lib; {
    description = "tomas";
    homepage = "https://github.com/tomasharkema/go-nixos-menu";
    license = licenses.mit;
    maintainers = ["tomasharkema" "tomas@harkema.io"];
  };
}
