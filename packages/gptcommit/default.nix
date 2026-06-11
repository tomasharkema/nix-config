{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gptcommit";
  version = "0.5.17";

  src = fetchFromGitHub {
    owner = "zurawiki";
    repo = "gptcommit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MB78QsJA90Au0bCUXfkcjnvfPagTPZwFhFVqxix+Clw=";
  };

  cargoHash = "sha256-PFpc9z45k0nlWEyjDDKG/U8V7EwR5b8rHPV4CmkRers=";

  doCheck = false;

  meta = {
    description = "A git prepare-commit-msg hook for authoring commit messages with LLMs";
    homepage = "https://github.com/zurawiki/gptcommit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "gptcommit";
  };
})
