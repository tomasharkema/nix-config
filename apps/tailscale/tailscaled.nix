{ pkgs, lib, ... }:
pkgs.buildGoModule rec {
  pname = "tailscalesd";
  version = "0.2.2-1";

  src = pkgs.fetchFromGitHub {
    owner = "tomasharkema";
    repo = "tailscalesd";
    rev = "e41dd0bcb07757f45728e09ea0d9e42be1819ba9";
    hash = "sha256-avPGzubYttXoESzKcfvewxk/A8CcymQRTNyshRel45M=";
  };

  vendorHash = "sha256-7/w5Mw3+CKqIT+KQVGTb1vPcYz5z+joR18dzOb3zVw0=";

  meta = with lib; {
    description = "tomas";
    homepage = "https://github.com/tomasharkema/nix-config";
    license = licenses.mit;
    maintainers = with maintainers; [ tomasharkema ];
  };

  env = {
    ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
  };
}
