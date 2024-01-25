{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "telegrammer";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "giano";
    repo = pname;
    rev = "master";
    hash = "sha256-3UVqJJqByt61uu3/7/ruoMx5KQK7G0YP7X1gVvu/3Lc=";
  };

  npmDepsHash = "sha256-LV74W3T07dMOhx5envWt4vN5Sl2EmZHylsHqwDLFKfg="; # "sha256-5p7q09jQYQJw7FzgPTWyS2QpjTydBo0ImbbatVaardU=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  makeCacheWritable = true;

  npmFlags = ["--legacy-peer-deps"];
  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = ["--ignore-scripts"];

  # NODE_OPTIONS = "--openssl-legacy-provider";
  # dontBuild = true;
  # dontNpmBuild = true;
}
