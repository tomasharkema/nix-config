# https://github.com/balena-io/etcher/releases/download/v1.19.25/balenaEtcher-1.19.25-x64.AppImage
{
  lib,
  appimageTools,
  fetchurl,
}: let
  version = "1.19.25";
  pname = "etcher";
  src = fetchurl {
    url = "https://github.com/balena-io/etcher/releases/download/v${version}/balenaEtcher-${version}-x64.AppImage";
    hash = "sha256-Dj3KJeCeEbnShF2YahCkRRBzMX8KowEmoGOq9HpNCpk=";
  };
  name = pname;
  appimageContents = appimageTools.extractType1 {inherit name src;};
in
  appimageTools.wrapType2 {
    inherit name src;

    # extraInstallCommands = ''
    #   mv $out/bin/${name} $out/bin/${pname}
    #   install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    #   substituteInPlace $out/share/applications/${pname}.desktop \
    #     --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    #   cp -r ${appimageContents}/usr/share/icons $out/share
    # '';

    meta = {
      description = "Viewer for electronic invoices";
      homepage = "https://github.com/ZUGFeRD/quba-viewer";
      downloadPage = "https://github.com/ZUGFeRD/quba-viewer/releases";
      license = lib.licenses.asl20;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      maintainers = with lib.maintainers; [];
      platforms = ["x86_64-linux"];
    };
  }
