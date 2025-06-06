{
  lib,
  python3,
  fetchFromGitHub,
  tlp,
  gtk3,
  gobject-introspection,
  wrapGAppsHook,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "tlpui";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "d4nj1";
    repo = "TLPUI";
    rev = "tlpui-${version}";
    hash = "sha256-JRchkgH8efFWpLbYWwgrWo7bMXwvGP0oHyXG4h65Y+A=";
  };

  build-system = [python3.pkgs.poetry-core];

  nativeBuildInputs = with python3.pkgs; [
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pyyaml
    tlp
    gtk3
  ];

  runtimeDependencies = with python3.pkgs; [
    gtk3
  ];

  pythonImportsCheck = ["tlpui"];
  postPatch = ''
    substituteInPlace tlpui/settings.py \
      --replace-fail "FOLDER_PREFIX = \"/var/run/host\" if IS_FLATPAK else \"\"" "FOLDER_PREFIX = \"/run/current-system/sw\""
  '';

  dontWrapGApps = true;
  makeWrapperArgs = [
    "--prefix 'PATH' ':' 'lib.makeBinPath [tlp]}'"
    ''"''${gappsWrapperArgs[@]}"''
  ];

  meta = with lib; {
    description = "A GTK user interface for TLP written in Python";
    homepage = "https://github.com/d4nj1/TLPUI";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [];
    mainProgram = "tlpui";
  };
}
