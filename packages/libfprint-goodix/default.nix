{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  autoPatchelfHook,
  cmake,
  glib,
  gusb,
  cairo,
  gobject-introspection,
  nss,
  udev,
  libgudev,
  gtk-doc,
  udevCheckHook,
  docbook_xsl,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libfprint-goodix";
  version = "0-unstable-2026-04-07";

  src = fetchFromGitHub {
    owner = "W3D3";
    repo = "libfprint";
    rev = "f3ccc41f9c5cf6b57d033a3dbc790ddd671c4445";
    hash = "sha256-36c8JtaRxhNpLK+tnbzBZfnDs94Wi2zAb76vwtPQiuo=";
  };

  # mesonFlags = [
  #   (lib.mesonOption "udev_rules_dir" "${placeholder "out"}/lib/udev")
  #   (lib.mesonOption "udev_hwdb_dir" "${placeholder "out"}/udev/udev/hwdb.d")
  # ];

  postPatch = ''
    patchShebangs \
      tests/test-runner.sh \
      tests/unittest_inspector.py \
      tests/virtual-image.py \
      tests/umockdev-test.py \
      tests/test-generated-hwdb.sh

    # substituteInPlace meson.build \
    #   --replace-fail "1.94.5" "1.94.9"
  '';

  mesonFlags = [
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
    # Include virtual drivers for fprintd tests
    "-Ddrivers=all"
    "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d"
  ];

  nativeInstallCheckInputs = [
    (python3.withPackages (p: with p; [pygobject3]))
  ];

  # We need to run tests _after_ install so all the paths that get loaded are in
  # the right place.
  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    ninjaCheckPhase

    runHook postInstallCheck
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    udevCheckHook
    gtk-doc
    autoPatchelfHook
    glib
  ];

  buildInputs = [
    cmake
    gusb
    docbook_xsl
    cairo
    nss
    gobject-introspection
    libgudev
    udev
  ];

  meta = {
    description = "Library for fingerprint readers";
    homepage = "https://github.com/W3D3/libfprint";
    changelog = "https://github.com/W3D3/libfprint/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "libfprint";
    platforms = lib.platforms.all;
  };
})
