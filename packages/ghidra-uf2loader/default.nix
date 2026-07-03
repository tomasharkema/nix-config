{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  ghidra,
}:
ghidra.buildGhidraExtension (finalAttrs: {
  pname = "ghidra-uf2loader";
  version = "1.4";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wyattearp";
    repo = "ghidra_uf2loader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-99ft7VaiOPs+bXTwTO4fcpVeLip1e1K+EudcgCqYj/I=";
  };

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Provides a better than raw binary loader for UF2 files in Ghidra";
    homepage = "https://github.com/wyattearp/ghidra_uf2loader";
    changelog = "https://github.com/wyattearp/ghidra_uf2loader/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "ghidra-uf2loader";
    platforms = lib.platforms.all;
  };
})
