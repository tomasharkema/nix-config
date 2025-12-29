{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook4,
  qt6Packages,
  cmake,
  ninja,
  pkg-config,
  openssl,
  pulseaudioFull,
}:
stdenv.mkDerivation rec {
  pname = "librepods";
  version = "0.1.0-rc.4";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    rev = "main";
    hash = "sha256-Ckw6zQf3lDLFh81594XhXz/B9gPkMws1Li4l+Fr+09k="; # "sha256-vWtBSHYPtrSmYzY25a1RcVUlpaXF2WzNLke7RiST/38=";
  };

  sourceRoot = "${src.name}/linux";

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja

    qt6Packages.wrapQtAppsHook
    wrapGAppsHook4
  ];

  buildInputs = [
    # qt6Packages.qtbase
    qt6Packages.qtquick3d
    qt6Packages.qtdeclarative
    qt6Packages.qtmultimedia
    qt6Packages.qtquicktimeline
    qt6Packages.qtconnectivity
    qt6Packages.qtwayland
    qt6Packages.qtsvg
    qt6Packages.qttools
    openssl
    pulseaudioFull
  ];

  qtWrapperArgs = [
    "--unset QT_QPA_PLATFORMTHEME"
    "--unset QT_STYLE_OVERRIDE"
  ];
  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  postInstall = ''
    cp $out/share/applications/me.kavishdevar.librepods.desktop $out/share/applications/me.kavishdevar.librepods.autostart.desktop

    substituteInPlace $out/share/applications/me.kavishdevar.librepods.autostart.desktop \
      --replace-fail "Exec=librepods" "Exec=librepods --hide"
  '';
  meta = {
    description = "AirPods liberated from Apple's ecosystem";
    homepage = "https://github.com/kavishdevar/librepods";
    changelog = "https://github.com/kavishdevar/librepods/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "librepods";
    platforms = lib.platforms.all;
  };
}
