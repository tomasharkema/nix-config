{
  pulls ? ./test-pr.json,
  nixpkgs ? <nixpkgs>,
  ...
}: let
  pkgs = import nixpkgs {};
in
  with import ./lib.nix;
  with pkgs.lib; let
    defaults = {
      enabled = 1;
      hidden = false;
      keepnr = 10;
      schedulingshares = 100;
      checkinterval = 0; # 3600;
      enableemail = false;
      emailoverride = "";
      # nixexprinput = "config";
      # nixexprpath = "default.nix";
    };
    primary_jobsets = {
      nix-config-main =
        defaults
        // {
          description = "nix-config-main";
          type = 1;
          flake = "github:tomasharkema/nix-config/main";
        };
    };
    pr_data = builtins.fromJSON (builtins.readFile pulls);
    makePr = num: info: {
      name = "nix-config-${num}";
      value =
        defaults
        // {
          description = "PR ${num}: ${info.title}";
          # inputs = {
          #   config = mkFetchGithub "https://github.com/${info.head.repo.owner.login}/${info.head.repo.name}.git ${info.head.ref}";
          #   nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs nixos-unstable-small";
          # };
          type = 1;
          flake = "github:tomasharkema/nix-config/${info.head.ref}";
        };
    };
    pull_requests = listToAttrs (mapAttrsToList makePr pr_data);
    jobsetsAttrs = pull_requests // primary_jobsets;
  in {
    jobsets = makeJobsets jobsetsAttrs;
  }
