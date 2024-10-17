{
  lib,
  stdenv,
  dpkg,
  tree,
  autoPatchelfHook,
  brscan5,
  sane-backends,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "brscan-skey";
  version = "0.3.2-0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006652/brscan-skey-0.3.2-0.amd64.deb";
    sha256 = "00vcj5q2k2lw466r1xlzq2741s0i9af7g9q6057w8qy46b0l2k9x";
  };

  nativeBuildInputs = [dpkg autoPatchelfHook sane-backends];
  buildInputs = [brscan5 sane-backends];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    cp -r opt/brother/scanner/brscan-skey/* $out/lib/
    cp opt/brother/scanner/brscan-skey/brscan-skey $out/bin/

    substituteInPlace $out/bin/brscan-skey \
      --replace-fail "/opt/brother/scanner/brscan-skey" "$out/lib"

    substituteInPlace "$out/lib/brscan-skey.config" \
      --replace-fail "/opt/brother/scanner/brscan-skey" "$out/lib"
    substituteInPlace "$out/lib/brscan_mail.config" \
      --replace-fail "/opt/brother/scanner/brscan-skey" "$out/lib"
    # substituteInPlace "$out/lib/scantoemail.config" \
    #   --replace-fail "/opt/brother/scanner/brscan-skey" "$out/lib"
    # substituteInPlace "$out/lib/scantofile.config" \
    #   --replace-fail "/opt/brother/scanner/brscan-skey" "$out/lib"
    # substituteInPlace "$out/lib/scantoimage.config" \
    #   --replace-fail "/opt/brother/scanner/brscan-skey" "$out/lib"

    runHook postInstall
  '';
}
