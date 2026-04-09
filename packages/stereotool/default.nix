{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
}:
stdenv.mkDerivation {
  pname = "stereotool";
  version = "0.0.1";

  src = fetchzip {
    url = "https://download.thimeo.com/StereoTool_Linux64.zip";
    sha256 = "sha256-MGUdvCn/lBygSG/NEzUJtxomHfAUtFtN7oKDDfCQrEI=";
    stripRoot = false;
  };

  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [];

  postInstall = ''
    install -D ./stereo_tool_gui $out/bin/stereo_tool_gui
    chmod +x $out/bin/stereo_tool_gui
  '';
}
