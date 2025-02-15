{
  stdenv,
  fetchzip,
  systemdUkify,
  cdrtools,
}:
stdenv.mkDerivation {
  pname = "gparted-live";
  version = "1.7.0-1";
  src = fetchzip {
    url = "https://downloads.sourceforge.net/project/gparted/gparted-live-stable/1.7.0-1/gparted-live-1.7.0-1-amd64.zip";
    sha256 = "sha256-h2NjKlLT2DZQNt7sqRGeIdor0NeaE8ogJ3Dkt8XZhLM=";
    stripRoot = false;
  };

  buildInputs = [systemdUkify cdrtools];

  installPhase = ''
    ls -la
    mkdir -p $out/{opt,efi}
    cp -r . $out/opt

    ukify build \
      --linux="live/vmlinuz" \
      --initrd="live/initrd.img" \
      --initrd="live/filesystem.squashfs" \
      --uname="$(cat live/GParted-Live-Version | head -n 1)" \
      --os-release="live/GParted-Live-Version" \
      --measure \
      --cmdline="boot=live config components union=overlay username=user noswap noeject vga=788" \
      --output=$out/efi/gparted.efi


    mkisofs -o $out/opt/efi.iso -graft-points /EFI/gparted.iso=$out/efi/gparted.efi

  '';
  # --cmdline="debug init=${installer}/init" \
}
