# Generated by pip2nix 0.8.0.dev1
# See https://github.com/nix-community/pip2nix
{
  pkgs,
  fetchurl,
  fetchgit,
  fetchhg,
}: self: super: {
  "bullet" = super.buildPythonPackage rec {
    pname = "bullet";
    version = "1.0.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/37/16/409aa2852add2bf79f299f7ce6d48771b7950dbb1e6b3a14a4610879675b/bullet-1.0.0-py3-none-any.whl";
      sha256 = "127c11w1lpva8qca48xppgfvahyxq2dm4sbspwrhizcfplnwhhzm";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
  };
}
