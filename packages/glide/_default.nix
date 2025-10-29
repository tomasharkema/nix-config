{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "glide";
  version = "unstable-2023-09-22";

  src = fetchFromGitHub {
    owner = "StellarSand";
    repo = "GLIDE";
    rev = "525581efba9788299e90bd1633febcaacfcfec07";
    hash = "sha256-DajHUQEtXMP/q8TpAKNOkmqH7mLSS04vXlm0T4edsic=";
  };

  installPhase = ''
    install -D common_utils.sh $out/lib/glide/common_utils.sh
    cp -r distros $out/lib/glide/
    cp -r conf $out/lib/glide/
    install -D glide.sh $out/bin/glide

    for f in $(find $out -executable -type f); do
      substituteInPlace $f \
        --replace-fail "/usr/local/lib/GLIDE/" "$out/lib/glide/" \
        --replace-warn "curl -L -o" "wget2 -c -O"
    done
  '';

  meta = {
    description = "Download and verify latest GNU/Linux ISO directly from terminal";
    homepage = "https://github.com/StellarSand/GLIDE";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "glide";
    platforms = lib.platforms.all;
  };
}
