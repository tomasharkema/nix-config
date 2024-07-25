# https://github.com/pzmarzly/ancs4linux
{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
  inputs,
  pkgs,
  glib,
  gobject-introspection,
}: let
  p2n = inputs.poetry2nix.lib.mkPoetry2Nix {inherit pkgs;};
  p2nix = p2n.overrideScope (final: prev: {
    # pyself & pyprev refers to python packages
    defaultPoetryOverrides =
      prev.defaultPoetryOverrides.extend
      (pyfinal: pyprev: {
        hatchling = python3Packages.hatchling;
        pygobject = python3Packages.pygobject3;
        pygobject3 = python3Packages.pygobject3;
        dbus-python = python3Packages.dbus-python;
      });
  });
in (p2nix.mkPoetryApplication {
  pname = "ancs4linux";
  version = "0.0.1-ce8d3f1";
  # format = "pyproject";

  projectDir = fetchFromGitHub {
    owner = "pzmarzly";
    repo = "ancs4linux";
    rev = "ce8d3f173fd14566e516334ef23af632d840d64e";
    hash = "sha256-iP4OkWvX2RjMPQYoR+erQoB10d7+4NKYFsJoZUqhcDs=";
  };
  # nativeBuildInputs = with python3Packages; [pygobject3];
  propagatedBuildInputs = with python3Packages; [glib gobject-introspection dbus-python pygobject3];
  nativeBuildInputs = with python3Packages; [glib gobject-introspection dbus-python pygobject3];
  preferWheels = true;

  postInstall = ''
    install -Dm 644 autorun/ancs4linux-observer.service $out/lib/systemd/system/ancs4linux-observer.service
    install -Dm 644 autorun/ancs4linux-observer.xml $out/share/dbus-1/system.d/ancs4linux-observer.conf
    install -Dm 644 autorun/ancs4linux-advertising.service $out/lib/systemd/system/ancs4linux-advertising.service
    install -Dm 644 autorun/ancs4linux-advertising.xml $out/share/dbus-1/system.d/ancs4linux-advertising.conf
    install -Dm 644 autorun/ancs4linux-desktop-integration.service $out/lib/systemd/user/ancs4linux-desktop-integration.service


    substituteInPlace "$out/lib/systemd/system/ancs4linux-observer.service" \
      --replace-fail "/usr/local/bin" "$out/bin"

    substituteInPlace "$out/lib/systemd/system/ancs4linux-advertising.service" \
      --replace-fail "/usr/local/bin" "$out/bin"

    substituteInPlace "$out/lib/systemd/user/ancs4linux-desktop-integration.service" \
      --replace-fail "/usr/local/bin" "$out/bin"
  '';
})
# substituteInPlace "$out/lib/systemd/system/ancs4linux-observer.service" \
#   --replace "/usr/local/bin/ancs4linux-advertising" "$out/bin/ancs4linux-advertising" \
#   --replace "/usr/local/bin/ancs4linux-observer" "$out/bin/ancs4linux-observer" \
#   --replace "/usr/local/bin/ancs4linux-desktop-integration" "$out/bin/ancs4linux-desktop-integration"
# substituteInPlace "$out/lib/systemd/system/ancs4linux-advertising.service" \
#   --replace "/usr/local/bin/ancs4linux-advertising" "$out/bin/ancs4linux-advertising" \
#   --replace "/usr/local/bin/ancs4linux-observer" "$out/bin/ancs4linux-observer" \
#   --replace "/usr/local/bin/ancs4linux-desktop-integration" "$out/bin/ancs4linux-desktop-integration"
# substituteInPlace "$out/lib/systemd/user/ancs4linux-desktop-integration.service" \
#   --replace "/usr/local/bin/ancs4linux-advertising" "$out/bin/ancs4linux-advertising" \
#   --replace "/usr/local/bin/ancs4linux-observer" "$out/bin/ancs4linux-observer" \
#   --replace "/usr/local/bin/ancs4linux-desktop-integration" "$out/bin/ancs4linux-desktop-integration"

