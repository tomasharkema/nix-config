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
      checkinterval = 600;
      enableemail = false;
      emailoverride = "";
      # nixexprinput = "config";
      # nixexprpath = "default.nix";
    };
    primary_jobsets = {
      nix-config-snowfall =
        defaults
        // {
          description = "nix-config";
          # inputs = {
          #   config = mkFetchGithub "https://github.com/tomasharkema/nix-config snowfall";
          #   nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs nixos-unstable-small";
          # };

          type = 1;
          flake = "git+https://github.com/tomasharkema/nix-config.git?ref=snowfall";
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
          flake = "git+https://github.com/tomasharkema/nix-config.git?rev=${info.head.ref}";
        };
    };
    pull_requests = listToAttrs (mapAttrsToList makePr pr_data);
    jobsetsAttrs = pull_requests // primary_jobsets;
  in {
    jobsets = makeSpec jobsetsAttrs;
  }
