{
  #nixos-conf-editor,
   ...}: final: prev: {
  # nixos-conf-editor = nixos-conf-editor.packages.${prev.system}.nixos-conf-editor;
}
