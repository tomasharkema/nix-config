{pkgs, ...}: {
  # packages-json = pkgs.writeShellScriptBin "packages-json" ./packages-json.sh;

  packages-json = pkgs.writeShellApplication {
    name = "packages-json";
    runtimeInputs = with pkgs; [jq gum nix-eval-jobs];
    text = ./packages-json.sh;
  };
}
