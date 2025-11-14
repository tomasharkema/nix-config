{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  cups,
  rmapi,
}:
stdenvNoCC.mkDerivation (
  finalAttrs: {
    pname = "remarkable-cups";
    version = "unstable-2022-06-18";

    src = fetchFromGitHub {
      owner = "ofosos";
      repo = "scratch";
      rev = "bc2e2a812168b1b1207271da3ded90812e15d558";
      hash = "sha256-Nufq9tpZtieGOh3LG5GdjFEJqtFZD/4LZWflcyhQOZI=";
    };

    buildInputs = [
      cups
      rmapi
    ];

    sourceRoot = "${finalAttrs.src.name}/remarkable-cups";

    CUPS_DATADIR = "${cups}/share/cups";

    buildPhase = ''
      ${cups}/bin/ppdc remarkable.drv
    '';

    installPhase = ''
      install -D ppd/remarkable.ppd $out/share/cups/model/remarkable.ppd
      install -Dm 700 remarkable.sh $out/share/cups/backend/remarkable

      substituteInPlace $out/share/cups/backend/remarkable \
        --replace-fail "/home/mark/gosrc/bin/rmapi" "${rmapi}/bin/rmapi"
    '';

    meta = {
      description = "Public scratchpad";
      homepage = "https://github.com/ofosos/scratch";
      license = lib.licenses.unfree; # FIXME: nix-init did not find a license
      maintainers = with lib.maintainers; [];
      mainProgram = "scratch";
      platforms = lib.platforms.all;
    };
  }
)
