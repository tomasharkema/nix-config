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

  npmDepsHash = "sha256-5p7q09jQYQJw7FzgPTWyS2QpjTydBo0ImbbatVaardU=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  # The prepack script runs the build script, which we'd rather do in the build phase.
  # npmPackFlags = ["--ignore-scripts"];

  # NODE_OPTIONS = "--openssl-legacy-provider";
  dontBuild = true;
  dontNpmBuild = true;
}
