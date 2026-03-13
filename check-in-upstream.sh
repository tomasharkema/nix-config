#!/bin/sh

set -e
# set -x

checkPackage() {
	name=$1

	tput sc
	tput el

	echo "check: $name"

	availableVersion=$(nix eval nixpkgs#"$name".version 2>/dev/null || true)

	if [ -z "$availableVersion" ]; then
		tput rc
		return
	fi

	echo " "
	echo "===="
	echo " "
	echo "Found version for $name: $availableVersion"

	availableUrl=$(nix eval nixpkgs#"$name".src.gitRepoUrl 2>/dev/null || nix eval nixpkgs#"$name".src.url 2>/dev/null)
	localUrl=$(nix eval .#"$name".src.gitRepoUrl 2>/dev/null || nix eval .#"$name".src.url 2>/dev/null)
	localVersion=$(nix eval .#"$name".version 2>/dev/null)

	echo "Local version: $localVersion: $availableUrl"
	echo "availableUrl: $availableUrl"
	echo "localUrl: $localUrl"
	echo " "
	echo "===="
	echo " "
}

# ls -la packages/**/default.nix
iterateFolder() {
	for d in packages/*; do
		name=$(basename "$d")

		checkPackage "$name"

	done
}

iterateFolder
