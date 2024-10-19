{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gh-worktree";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "despreston";
    repo = "gh-worktree";
    rev = "v${version}";
    hash = "sha256-Ov06RwEopV5jIRnoRYE5I7YU68ahHgkUVwDqoVpTESk=";
  };

  vendorHash = "sha256-iplbhXKfMrXIhynS8MOOxvpWO5z+gKJKBLk6AGeCBi4=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Worktrees and Github";
    homepage = "https://github.com/despreston/gh-worktree";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "gh-worktree";
  };
}
