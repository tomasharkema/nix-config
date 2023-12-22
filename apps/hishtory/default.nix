{ lib, pkgs, ... }: rec {
  # https://github.com/ddworken/hishtory

  hishtory = lib.stdenv.buildGoModule rec {

    pname = "hishtory";
    version = "0.263";

    goPackagePath = "github.com/ddworken/hishtory";

    allowGoReference = true;

    src = pkgs.fetchFromGitHub {
      owner = "ddworken";
      repo = "hishtory";
      rev = "v${version}";
      hash = "sha256-aVmzrYzFws6MlUnzhz4DaCp4NWGkhKeVyeezdlaBGts=";
    };

    meta = with lib; {
      description = "Simple command-line snippet manager, written in Go";
      homepage = "https://github.com/knqyf263/pet";
      license = licenses.mit;
      maintainers = with maintainers; [ kalbasit ];
    };

    vendorHash = "AAAA";
  };
}
