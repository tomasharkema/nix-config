{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "netconsd";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "netconsd";
    rev = "v${version}";
    hash = "sha256-FIbl/zZvQSvT+ZSjgEosj6wyI9VLvoZcpyPXH+uTGJs=";
  };

  installPhase = ''
    mkdir -p $out/{bin,lib}
    install -D netconsd $out/bin/netconsd
    cp -r modules/*.so $out/lib
  '';

  nativeBuildInputs = [autoPatchelfHook];

  meta = {
    description = "Receive and process logs from the Linux kernel";
    homepage = "https://github.com/facebook/netconsd";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [];
    mainProgram = "netconsd";
  };
}
