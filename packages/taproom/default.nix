{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:
buildGoModule (finalAttrs: {
  pname = "taproom";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "hzqtc";
    repo = "taproom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-s0RU7fz64OO+XIVNT4UEWDKkpw0a17DGqdqKaWfjOUE=";
  };

  nativeBuildInputs = [makeWrapper];
  vendorHash = "sha256-HCOLyQjAVy0B60HRQviWB9zI8sbw4CW4ZIKbN70gM5A=";

  ldflags = ["-s"];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/taproom --prefix PATH "/opt/homebrew/bin"
  '';

  meta = {
    description = "";
    homepage = "https://github.com/hzqtc/taproom";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "taproom";
  };
})
