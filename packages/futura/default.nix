{
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "futura";
  version = "2";

  srcs = [
    (fetchzip {
      url = "https://font.download/dl/font/futura-pt.zip";
      sha256 = "sha256-BQTPoD8nY/NQLyWw4CAwhwks0hWFP/r/bLLCQ8i4W+w=";
      stripRoot = false;
      name = "source-futura-pt";
    })
    (fetchzip {
      url = "https://www.wfonts.com/download/data/2015/03/12/futura/futura.zip";
      sha256 = "sha256-QtcPTbs45kIRJJiacvhItYXymsJhd/IvC8o68NQrJqo=";
      stripRoot = false;
      name = "source-futura";
    })
    (fetchzip {
      url = "https://drive.google.com/uc?id=12sK8sYhNo1Z9wv8UTlfXwhDjq9x0Ntd2&export=download";
      sha256 = "sha256-IVZlpuLrWCxm77xVhErxrFdjGcrxi2SqSCVMCt4YseM=";
      stripRoot = false;
      name = "source-futura-cdnfonts";
      extension = "zip";
    })
    (fetchzip {
      url = "https://drive.google.com/uc?id=1KNpKSzMyouPqaKOPRV5efYY03F6DMYNg&export=download";
      sha256 = "sha256-ekCiliuJoRdVRDDPs79wC7k77jBugdVNa7D2fl5p3CQ=";
      stripRoot = false;
      name = "source-futura-nd";
      extension = "zip";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    install -Dm444 source-futura/*.ttf -t $out/share/fonts/ttf
    install -Dm444 source-futura-pt/*.ttf -t $out/share/fonts/ttf
    install -Dm444 source-futura-cdnfonts/*.otf -t $out/share/fonts/otf

    install -Dm444 "source-futura-nd/Futura ND/Futura ND Medium/Futura ND Medium.ttf" -t $out/share/fonts/ttf
    install -Dm444 "source-futura-nd/Futura ND/Futura ND Medium Oblique/Futura ND Medium Oblique.ttf" -t $out/share/fonts/ttf
  '';
}
