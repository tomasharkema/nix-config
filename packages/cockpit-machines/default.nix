{
  lib,
  stdenv,
  fetchzip,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-machines";
  version = "324";

  src = fetchzip {
    sha256 = "1xd3705q2h6vy2sx1wamm4myld484klfzy4rgf81a55kcvy92g8a";
    url = "https://github.com/cockpit-project/cockpit-machines/releases/download/${version}/cockpit-machines-${version}.tar.xz";
  };

  nativeBuildInputs = [gettext];

  makeFlags = ["DESTDIR=$(out)" "PREFIX="];

  # postPatch = ''
  #   substituteInPlace Makefile \
  #     --replace /usr/share $out/share
  #   touch pkg/lib/cockpit.js
  #   touch pkg/lib/cockpit-po-plugin.js
  #   touch dist/manifest.json
  # '';

  postFixup = ''
    substituteInPlace $out/share/cockpit/machines/manifest.json \
      --replace-warn "/usr" "/run/current-system/sw"
  '';
  #   gunzip $out/share/cockpit/machines/index.js.gz
  #   sed -i "s#/usr/bin/python3#/usr/bin/env python3#ig" $out/share/cockpit/machines/index.js
  #   sed -i "s#/usr/bin/pwscore#/usr/bin/env pwscore#ig" $out/share/cockpit/machines/index.js
  #   gzip -9 $out/share/cockpit/machines/index.js
  # '';

  dontBuild = true;

  meta = {
    description = "Cockpit UI for virtual machines";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/cockpit-project/cockpit-machines";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}
