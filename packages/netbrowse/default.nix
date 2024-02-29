{
  fetchFromGitHub,
  rustPlatform,
  fetchCrate,
  xorg,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "netbrowse";
  version = "0.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-dA8oDeQSPDPXPAgX6jPLLPWXxje+1L80zC8SVaQ2WTs=";
  };

  cargoSha256 = "sha256-FzKDKm3TJNelDRUL3BJp8UJnjrCb++g1osXOT6X55ho=";

  buildInputs = [xorg.libxcb xorg.libX11 makeWrapper];

  postInstall = ''
    wrapProgram $out/bin/netbrowse --prefix LD_LIBRARY_PATH : "${xorg.libX11.out}/lib"
  '';
}
