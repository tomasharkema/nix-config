{
  fetchgit,
  stdenv,
  fetchzip,
  getopt,
  lib,
}:
fetchgit {
  url = "https://review.coreboot.org/coreboot";
  # todo - extract from libreboot resources/coreboot/default/board.cfg
  rev = "ef24143cc4831fc79b7689349bc9d8e33b425f20"; # libreboot's rev
  hash = "";
  fetchSubmodules = true;
  leaveDotGit = true;
  postFetch = ''
    PATH=${lib.makeBinPath [getopt]}:$PATH ${stdenv.shell} $out/util/crossgcc/buildgcc -W > $out/.crossgcc_version
    rm -rf $out/.git
  '';
  allowedRequisites = [];
}
