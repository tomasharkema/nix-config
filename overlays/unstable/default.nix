{channels, ...}: final: prev: {
  runitor = channels.unstable.runitor;

  vscode = channels.unstable.vscode;
  android-tools = channels.unstable.android-tools;
}
