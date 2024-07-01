{
  #  devenv,
  agenix,
  # nixos-anywhere,
  # nixos-conf-editor,
  nix-software-center,
  channels,
  # zjstatus,
  # manix,
  ...
}: final: prev: {
  # devenv = devenv.packages."${prev.system}".default;
  agenix = agenix.packages."${prev.system}".default;
  # nixos-anywhere = nixos-anywhere.packages."${prev.system}".nixos-anywhere;
  # nixos-conf-editor = nixos-conf-editor.packages."${prev.system}".nixos-conf-editor;
  nix-software-center = nix-software-center.packages."${prev.system}".nix-software-center;
  # nixUnstable = channels.unstable.nixVersions.latest;
  # nix = channels.unstable.nixVersions.latest;
  # manix = manix.packages."${prev.system}".manix;

  # zjstatus = zjstatus.packages."${prev.system}".default;

  nerdfonts =
    #   #channels.unstable
    prev.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "FiraCode"
        "FiraMono"
        "Terminus"
        "ComicShannsMono"
        "BigBlueTerminal"

        "OpenDyslexic"
        "Noto"
      ];
    };

  # attic-client = prev.attic-client.override {
  # nix = prev.nixVersions.nix_2_18;
  # };

  # devenv = prev.devenv.override {
  # nix = prev.nixVersions.nix_2_18;
  # };
  # .overrideAttrs (old: {
  #   nix = prev.nixVersions.nix_2_18;
  # });

  # tailscale =
  #   prev
  #   .tailscale
  #   # .override {
  #   #   buildGoModule = prev.buildGo122Module;
  #   # };
  #   .overrideAttrs
  #   (old: {
  #     ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.22";
  #   });

  # lib =
  #   (prev.lib.maintainers or {})
  #   // {
  #     tomas = {};
  #   };
}
