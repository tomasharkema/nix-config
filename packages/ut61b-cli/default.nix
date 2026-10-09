{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  libusb1,
  udevCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ut61b-cli";
  version = "1.0.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "lschw";
    repo = "ut61b-libusb-driver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M3ZLXgGIumbsJhD3aiEfGCHU4r/byHicKeiLZT3AJ0s=";
  };

  patches = [
    ./changes.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  nativeInstallCheckInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    install -D ./build/ut61b_cli $out/bin/ut61b-cli

    install -D ./utils/88-ut61b.rules $out/lib/udev/rules.d/88-ut61b.rules

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Libusb driver for the multimeter Uni-T UT61B";
    homepage = "https://github.com/lschw/ut61b-libusb-driver";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "ut61b-cli";
    platforms = lib.platforms.all;
  };
})
