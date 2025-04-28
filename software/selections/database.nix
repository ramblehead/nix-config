{
  pkgs,
  inputs,
}: {
  packages = with pkgs; [
    # SQLite
    # /b/{

    # dbeaver-bin # GUI for various SQL databases
    sqlitebrowser # DB Browser for SQLite
    sqlite

    # /b/}
  ];
}
