{ buildDotnetModule, fetchgit, gtk3, }:
buildDotnetModule {
  pname = "ntfy-desktop";
  version = "0.0.1";

  src = fetchgit {
    url = "https://codeberg.org/zvava/ntfy-desktop";
    sha256 = "sha256-nx3x4GiML7zNn4kw/d6lGMSCqGkMdpC5k4gjcEnwUu0=";
  };

  projectFile = "ntfy-desktop.Gtk/ntfy-desktop.Gtk.csproj";
  nugetDeps = ./deps.nix;

  buildInputs = [ gtk3 ];
}
