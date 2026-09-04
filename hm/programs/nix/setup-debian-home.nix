{
  pkgs,
  lib,
}: {
  setupNix = lib.hm.dag.entryAfter ["writeBoundary"] ''
    hm_vars_line='. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"'

    for file in "$HOME/.profile" "$HOME/.bashrc"; do
      if [ ! -f "$file" ]; then
        run touch "$file"
      fi

      if ! grep -Fxq "$hm_vars_line" "$file"; then
        run sh -c '
          {
            printf "%s\n" "$1"
            printf "%s\n" \
              "case \":\$PATH:\" in" \
              "  *\":\$HOME/.nix-profile/bin:\"*) ;;" \
              "  *) export PATH=\"\$HOME/.nix-profile/bin\''${PATH:+:}\$PATH\" ;;" \
              "esac"
            cat "$2"
          } > "$2.tmp" && mv "$2.tmp" "$2"
        ' _ "$hm_vars_line" "$file"
      fi
    done
  '';
}
