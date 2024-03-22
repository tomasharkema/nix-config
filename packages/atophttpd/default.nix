{
  stdenv,
  git,
}:
stdenv.mkDerivation rec {
  name = "atophttpd";
  version = "2.8.0";
  src = fetchTarball {
    url = "https://github.com/pizhenwei/atophttpd/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256:1zzsrg2zwc2sk44qv8a2lh18gdaxi54nznzhlalyg4jy4kbls53v";
  };
  buildInputs = [git];
}
