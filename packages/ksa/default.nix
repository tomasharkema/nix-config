{
  fetchzip,
  stdenvNoCC,
  autoPatchelfHook,
  libgcc,
  vulkan-loader,
}:
stdenvNoCC.mkDerivation {
  pname = "ksa";
  version = "2026.6.2.4531";

  src = fetchzip {
    url = "https://ksa-linux.aa5e8942dc923bc6bb7f40be4f2e4a41.r2.cloudflarestorage.com/setup_ksa_v2026.6.2.4531.tar.gz?X-Amz-Expires=86400&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=c8413af1083b474af8ba9d91e4defe93%2F20260607%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260607T204135Z&X-Amz-SignedHeaders=host&X-Amz-Signature=e9c02ecd5aa457640b89eeb37c5cfe25e4d66acf5f220677501fddc613abf055";
    extension = "tar.gz";
    sha256 = "sha256-eJoAsriPlA8zTjolR8aBh6oJLieCiVslKPJiTkYhSj8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libgcc.lib
    vulkan-loader
  ];

  preInstall = ''
    ls -lah .

    install -D ./Brutal.Monitor.Subprocess $out/bin/Brutal.Monitor.Subprocess
    install -D ./KSA $out/bin/KSA

    chmod +x $out/bin/Brutal.Monitor.Subprocess
    chmod +x $out/bin/KSA

    cp -rv ./Content/ $out/bin/Content/

    mkdir $out/lib/
    cp -rv ./*.so $out/lib/
    cp -rv ./*.so* $out/lib/
  '';
}
