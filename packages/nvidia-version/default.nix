{
  writeShellApplication,
  mktemp,
  wget2,
  jq,
  pup,
}:
writeShellApplication {
  name = "nvidia-version";

  runtimeInputs = [mktemp wget2 jq pup];

  text = ''
    set -e

    TMPFILE="$(mktemp)"
    trap 'rm -rf -- "$TMPFILE"' EXIT

    wget2 "https://www.nvidia.com/en-us/drivers/unix/" -O "$TMPFILE"

    pup "div#mainContent div#rightContent a json{}" < "$TMPFILE" | jq '.[range(0; 3)]'
  '';
}
