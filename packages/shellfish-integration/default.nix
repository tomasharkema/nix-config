{
  writeShellScript,
  writeText,
}:
writeText ".shellfishrc" (builtins.readFile ./shellfish-integration.sh)
