{
  lib,
  stdenv,
  fetchzip,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-files";
  version = "1";

  src = fetchzip {
    # url = "https://github.com/cockpit-project/cockpit-files/download/${version}/cockpit-machines-${version}.tar.xz";
    url = "https://github.com/cockpit-project/cockpit-files/archive/07f93dd656f0e6da1f57a5e5d53834635924ff61.zip";
    sha256 = "";
  };

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

  meta = with lib; {
    description = "Cockpit UI for local files";
    license = licenses.lgpl21;
    homepage = "https://github.com/cockpit-project/cockpit-files";
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
