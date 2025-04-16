{
  pkgs,
  inputs,
}: {
  packages = with pkgs; [
    # SQL
    # /b/{

    # dbeaver-bin # GUI for various SQL databases
    sqlitebrowser # DB Browser for SQLite

    # /b/}
  ];
}
