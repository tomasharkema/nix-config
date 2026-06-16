{
  stdenv,
  git,
  zlib,
  openssl,
  # nix-update-script,
  fetchFromGitHub,
  pkg-config,
}:
stdenv.mkDerivation rec {
  name = "atophttpd";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "pizhenwei";
    repo = "atophttpd";
    rev = "v${version}";
    sha256 = "sha256-/j04D7dRdRyAN36iISo+ndQERex5BtqbadVFDO4OH48="; # "sha256-exRN1yRekuepovDbb0mJXbWHAqRCoY0JmVow/sXL+v8=";
    fetchSubmodules = true;
  };

  makeFlags = ["DESTDIR=$(out)" "PREFIX=$(out)"];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/bin/" "/bin/" \
      --replace-fail "usr/share" "/share"

    substituteInPlace atophttpd.service \
      --replace-fail "/usr/bin" "$out/bin"
  '';

  buildPhase = ''
    runHook preBuild

    make bin

    runHook postBuild
  '';

  # postInstall = ''
  #   install -D $out/usr/bin/atophttpd $out/bin/atophttpd
  #   cp -r $out/usr/share/man $out/share
  #   rm -rf $out/usr
  # '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    git
    zlib
    openssl
  ];

  # passthru = {
  #   updateScript = nix-update-script {};
  # };
}
