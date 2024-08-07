{
  runCommand,
  lib,
  writeText,
  packages ? [],
  jq,
  sqlite,
  time,
}: let
  _packages =
    builtins.map (p: {
      name = p.pname or p.name or "";
      version = p.version or "";
    })
    packages;
  filtered = builtins.filter (v: (v.name != "shadow" && v.name != "" && v.version != "")) _packages;
  uniqueItems = lib.lists.unique filtered;
  formatted = builtins.toJSON uniqueItems;
  jsonFile = writeText "pkgs.json" formatted;

  csvFile = runCommand "pkgs.csv" {} "${jq}/bin/jq -r '(first|keys), (.[]|[.[]]) | @csv' ${jsonFile} > $out";

  sqlFile = writeText "pkgs.sql" ''
    BEGIN TRANSACTION;
      CREATE TABLE IF NOT EXISTS "pkgs" (
        "id"	INTEGER UNIQUE,
        "name"	TEXT NOT NULL COLLATE NOCASE,
        "version"	TEXT NOT NULL COLLATE NOCASE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );

      ${lib.concatStrings (builtins.map (v: ''
        INSERT INTO "pkgs" VALUES (NULL,'${v.name}','${v.version}');
      '')
      uniqueItems)}

      CREATE INDEX IF NOT EXISTS "idVersion" ON "pkgs" (
        "name"	COLLATE NOCASE,
        "version"	COLLATE NOCASE
      );
      CREATE INDEX IF NOT EXISTS "name" ON "pkgs" (
        "name"	COLLATE NOCASE
      );

    COMMIT;
    VACUUM;
    ANALYZE;
    PRAGMA optimize;
  '';
in
  runCommand "pkgs-index" {} ''
    mkdir $out

    cp ${jsonFile} $out/pkgs.json
    cp ${csvFile} $out/pkgs.csv
    cp ${sqlFile} $out/pkgs.sql

    echo "GENERATE INDEX..."
    cat "${sqlFile}" | ${lib.getExe sqlite} "$out/pkgs.db"

    echo "TESTING..."
    ${lib.getExe time} ${lib.getExe sqlite} "$out/pkgs.db" "EXPLAIN QUERY PLAN SELECT * FROM pkgs WHERE name LIKE 'nix%'"
    ${lib.getExe time} ${lib.getExe sqlite} "$out/pkgs.db" "SELECT * FROM pkgs WHERE name LIKE 'nix%'"
  ''
