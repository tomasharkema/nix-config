{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "ssh-proxy-agent";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "miquella";
    repo = "ssh-proxy-agent";
    rev = "8acc7e84787ab5cf9deb909af0f0dc4cf0cf8bc2";
    hash = "sha256-/zL/AasgqpdPPue13xspDOmU6IMZynfS0Q9Yv7vqveY=";
  };
  vendorHash = "sha256-EnddqIw7KkOrX6qjg1sA7Kp7FX96JV3mKZRbhWXOi64=";
}
