{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}: let
  rootFeed = "";

  feeds = [
    "https://raw.githubusercontent.com/Kapeli/feeds/master/Swift.xml"
  ];

  docsRoot = ".local/share/Zeal/Zeal/docsets";

  # https://github.com/hashhar/dash-contrib-docset-feed

  gtk4' = pkgs.gtk4.override {x11Support = true;};
  # gtkDocset = pkgs.runCommand "Gtk.docset" {} ''
  #   ${pkgs.custom.doc2dash}/bin/doc2dash ${gtk4'.devdoc}/share/doc/gtk4
  # '';
in {
  config = lib.mkIf pkgs.stdenv.isLinux {
    home = {
      packages = with pkgs; [zeal];
      file = {
        # "${docsRoot}/nixos-${pkgs.docset.version}.docset".source = "${pkgs.docset}/share/nixos-${pkgs.docset.version}.docset";
        # TODO: generate with doc2dash
        "${docsRoot}/Gtk.docset".source = "${pkgs.rtfm}/share/rtfm/docsets/Gtk.docset";
      };
    };
  };
}
