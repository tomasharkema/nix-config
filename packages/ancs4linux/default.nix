{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
  glib,
  gobject-introspection,
  wrapGAppsHook3,
  writeShellScript,
}: let
  startScript = writeShellScript "ancs4linux-start" ''
    address=$(@ancs4linux-ctl get-all-hci | jq -r '.[0]')
    @ancs4linux-ctl enable-advertising --hci-address $address --name $HOSTNAME
  '';
in
  python3.pkgs.buildPythonApplication rec {
    pname = "ancs4linux";
    version = "0.0.1-ce8d3f1";

    pyproject = true;

    src = fetchFromGitHub {
      owner = "tomasharkema";
      repo = "ancs4linux";
      rev = "ce8d3f173fd14566e516334ef23af632d840d64e";
      hash = "sha256-iP4OkWvX2RjMPQYoR+erQoB10d7+4NKYFsJoZUqhcDs=";
    };

    # src = fetchFromGitHub {
    #   owner = "pzmarzly";
    #   repo = "ancs4linux";
    #   rev = "ce8d3f173fd14566e516334ef23af632d840d64e";
    #   hash = "sha256-iP4OkWvX2RjMPQYoR+erQoB10d7+4NKYFsJoZUqhcDs=";
    # };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'typer = "^0.4.0"' 'typer = "^0.21.0"'
    '';

    build-system = [python3.pkgs.poetry-core];

    # nativeBuildInputs = with python3Packages; [pygobject3];
    propagatedBuildInputs = with python3.pkgs; [
      glib
      gobject-introspection
      dbus-python
      dasbus
      typer
      pygobject3
    ];

    nativeBuildInputs = with python3.pkgs; [
      glib
      gobject-introspection
      dbus-python
      dasbus
      typer
      pygobject3
      wrapGAppsHook3
    ];

    pythonImportsCheck = ["ancs4linux"];

    postInstall = ''
      install -Dm 644 autorun/ancs4linux-observer.service $out/lib/systemd/system/ancs4linux-observer.service
      install -Dm 644 autorun/ancs4linux-observer.xml $out/share/dbus-1/system.d/ancs4linux-observer.conf
      install -Dm 644 autorun/ancs4linux-advertising.service $out/lib/systemd/system/ancs4linux-advertising.service
      install -Dm 644 autorun/ancs4linux-advertising.xml $out/share/dbus-1/system.d/ancs4linux-advertising.conf
      install -Dm 644 autorun/ancs4linux-desktop-integration.service $out/lib/systemd/user/ancs4linux-desktop-integration.service

      install -Dm 644 ${startScript} $out/bin/ancs4linux-start
      chmod +x $out/bin/ancs4linux-start

      substituteInPlace "$out/lib/systemd/system/ancs4linux-observer.service" \
        --replace-fail "/usr/local/bin" "$out/bin"

      substituteInPlace "$out/lib/systemd/system/ancs4linux-advertising.service" \
        --replace-fail "/usr/local/bin" "$out/bin"

      substituteInPlace "$out/lib/systemd/user/ancs4linux-desktop-integration.service" \
        --replace-fail "/usr/local/bin" "$out/bin"

      substituteInPlace "$out/bin/ancs4linux-start" \
        --replace-fail '@ancs4linux-ctl' "$out/bin/ancs4linux-ctl"
    '';

    meta = {
      description = "Forward notifications from your iOS devices to your Linux desktop";
      homepage = "https://github.com/pzmarzly/ancs4linux";
      # license = lib.licenses.mit;
      maintainers = with lib.maintainers; [];
      # mainProgram = "ancs-linux";
    };
  }
