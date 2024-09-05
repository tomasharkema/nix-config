{
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  name = "term-ai";
  version = "1.1";
  src = fetchzip {
    url = "https://iterm2.com/downloads/ai-plugin/iTermAI-${version}.zip";
    sha256 = "sha256-CLYnXRavvT526UTd0P+lFEQQmdtD6c+A13aX7fYWgjE=";
  };
}
