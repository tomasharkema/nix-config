{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "graylog-dashboard";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "graylog-labs";
    repo = "cli-dashboard";
    rev = "v${version}";
    hash = "sha256-4x3gxaSxQ3eRniesHBmN5s/hDfsoXISRrEOEcxttMjA=";
  };

  dontNpmBuild = true;
  dontBuild = true;

  prePatch = ''
    ln -s ${./package-lock.json} package-lock.json
    ls -la
  '';

  npmDepsHash = "sha256-5p7q09jQYQJw7FzgPTWyS2QpjTydBo0ImbbatVaardU=";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  # npmPackFlags = ["--ignore-scripts"];

  # NODE_OPTIONS = "--openssl-legacy-provider";

  # meta = with lib; {
  #   description = "A modern web UI for various torrent clients with a Node.js backend and React frontend";
  #   homepage = "https://flood.js.org";
  #   license = licenses.gpl3Only;
  #   maintainers = with maintainers; [winter];
  # };
}
