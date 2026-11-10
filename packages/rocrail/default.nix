{
  stdenvNoCC,
  fetchzip,
  autoPatchelfHook,
  cairo,
  curlFull,
  fontconfig,
  gdk-pixbuf,
  glib,
  gtk3,
  wayland,
  libgcc,
  libjpeg8,
  libpng,
  libsm,
  libtiff,
  libwebp,
  libx11,
  libxkbcommon,
  libz,
  pango,
  copyDesktopItems,
  makeDesktopItem,
}: let
  isIntel = stdenvNoCC.hostPlatform.isx86_64;
  archName =
    if isIntel
    then "i64"
    else "ARM64";

  desktopItem = makeDesktopItem {
    name = "rocview";
    desktopName = "Rocview";
    comment = "Rocrail - Innovative Model Railroad Control System";
    exec = "rocview %U";
    icon = "rocrail.png";
    categories = ["Application"];
  };
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "rocrail";
    version = "7541";

    src = fetchzip {
      url = "https://www.rocrail-wiki.net/rocrail-snapshot/history/Rocrail-${finalAttrs.version}-debian11-${archName}.zip";
      sha256 =
        if isIntel
        then "sha256-U79m1HICwxyDXRJgPmAFyHQEQX/vIfIwLU45lIFvneE="
        else "";
      stripRoot = false;
    };

    desktopItems = [desktopItem];

    nativeBuildInputs = [
      autoPatchelfHook
      copyDesktopItems
    ];

    buildInputs = [
      cairo.out
      curlFull.out
      fontconfig.lib
      gdk-pixbuf.out
      glib.out
      gtk3.out
      wayland.out
      libgcc.lib
      libjpeg8.out
      libpng.out
      libsm.out
      libtiff.out
      libwebp.out
      libx11.out
      libxkbcommon.out
      libz.out
      pango.out
    ];

    postInstall = ''
      ls -la .
      mkdir -p $out/bin $out/lib
      cp -av . $out

      for file in `find $out/bin -name "*.so"`; do
        filename=`basename $file`
        dest="$out/lib/$filename"
        ln -s $file $dest
      done
    '';
  })
