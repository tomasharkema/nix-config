{ lib, fetchFromGitHub, stdenvNoCC, makeWrapper, gnupg, wget2, coreutils, }:
stdenvNoCC.mkDerivation rec {
  pname = "distrib-dl";
  version = "1.14.24";

  src = fetchFromGitHub {
    owner = "nodiscc";
    repo = "distrib-dl";
    rev = version;
    sha256 = "sha256-M6GHUhArLfYgkoQZWpzzte1muR+xLgtptaW0pUI6DWw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ gnupg wget2 coreutils ];

  installPhase = ''
    install -Dm 755 distrib-dl $out/bin/distrib-dl

    patchShebangs $out/bin/distrib-dl

    substituteInPlace $out/bin/distrib-dl \
      --replace "wget" "wget2" \
      --replace "--show-progress " ""


    wrapProgram $out/bin/distrib-dl --set PATH ${
      lib.makeBinPath [ gnupg wget2 coreutils ]
    }
  '';
}
