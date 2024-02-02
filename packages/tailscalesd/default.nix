{
  pkgs,
  lib,
  ...
}:
pkgs.buildGoModule rec {
  pname = "tailscalesd";
  version = "0.2.2-1";

  src = pkgs.fetchFromGitHub {
    owner = "tomasharkema";
    repo = "tailscalesd";
    rev = "4451cae097771df887eb45f7205de3609622744e";
    hash = "sha256-fElZz2UoWA4jOdcbpGt1p8wiSttiK9P9gIAciaglQmE=";
  };

  vendorHash = "sha256-7/W5Mw3+CKqIT+KQVGTb1vPcYz5q+joR18dzOb3zVw0=";

  meta = with lib; {
    description = "tomas";
    homepage = "https://github.com/tomasharkema/nix-config";
    license = licenses.mit;
    maintainers = ["tomasharkema" "tomas@harkema.io"];
  };

  env = {
    ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
  };
}
