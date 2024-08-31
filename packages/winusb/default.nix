{
  stdenv,
  fetchFromGitHub,
  wxGTK32,
  parted,
  makeWrapper,
  lib,
}:
stdenv.mkDerivation {
  pname = "winusb";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "0x00-0x00";
    repo = "WinUSB";
    rev = "1e5985c84e0f4d646b1c500d22330bd72e663a93";
    sha256 = "sha256-L1S2+hYRnYGgKp3jfFLYS0olY5hkMIqZSZdLRtZt4hQ=";
  };

  nativeBuildInputs = [makeWrapper];

  buildInputs = [wxGTK32 parted];

  postInstall = ''
    wrapProgram $out/bin/winusb --set PATH $PATH:${lib.makeBinPath [
      parted
    ]}
  '';
}
