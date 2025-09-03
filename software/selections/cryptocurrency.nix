{
  pkgs,
  pkgs-unstable,
  inputs,
}: {
  packages = with pkgs; [
    # bitcoin
    # /b/{

    bitcoin

    # /b/}

    # monero
    # /b/{

    monero-cli
    monero-gui
    p2pool
    xmrig

    # /b/}

    # solana
    # /b/{

    # pkgs-unstable.solana-cli
    # pkgs-unstable.anchor

    # /b/}
  ];
}
