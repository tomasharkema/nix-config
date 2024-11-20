{
  lib,
  stdenv,
  fetchzip,
  gettext,
  sources,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-files";
  version = "2";

  src = sources.cockpit-files;

  nativeBuildInputs = [
    gettext
  ];

  makeFlags = ["DESTDIR=$(out)" "PREFIX="];

  # postPatch = ''
  #   substituteInPlace Makefile \
  #     --replace /usr/share $out/share
  #   touch pkg/lib/cockpit.js
  #   touch pkg/lib/cockpit-po-plugin.js
  #   touch dist/manifest.json
  # '';

  # postFixup = ''
  #   gunzip $out/share/cockpit/machines/index.js.gz
  #   sed -i "s#/usr/bin/python3#/usr/bin/env python3#ig" $out/share/cockpit/machines/index.js
  #   sed -i "s#/usr/bin/pwscore#/usr/bin/env pwscore#ig" $out/share/cockpit/machines/index.js
  #   gzip -9 $out/share/cockpit/machines/index.js
  # '';

  dontBuild = true;

  meta = {
    description = "Cockpit UI for local files";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/cockpit-project/cockpit-files";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}
