{
  config,
  pkgs,
  lib,
  inputs,
}: let
  inherit (inputs) dotfiles;
in {
  setupMc = lib.hm.dag.entryAfter ["writeBoundary"] ''
    readonly MC_CONF="${config.home.homeDirectory}/.config/mc"
    # run mv -v "$MC_CONF" "''${MC_CONF}.$(date "+%Y%m%dT%H%M%S%3N%z")"
    run rm -rf "''${MC_CONF}~"
    run mv -v "$MC_CONF" "''${MC_CONF}~"
    run mkdir -p "$MC_CONF"
    run cp -n "${dotfiles}/.config/mc/ini" "$MC_CONF"
    run chmod ug+w "$MC_CONF/ini"

    run cp -f "${pkgs.mc}/etc/mc/mc.keymap" "$MC_CONF"
    run chmod ug+w "$MC_CONF/mc.keymap"

    run sed -i -E 's/^Store = ctrl-insert$/Store = ctrl-c; ctrl-insert/' \
              "$MC_CONF/mc.keymap"
    run sed -i -E 's/^Paste = shift-insert$/Paste = ctrl-v; shift-insert/' \
              "$MC_CONF/mc.keymap"
    run sed -i -E 's/^Cut = shift-delete$/Cut = ctrl-x; shift-delete/' \
              "$MC_CONF/mc.keymap"
    run sed -i -E 's/^Undo = ctrl-u$/\0; ctrl-z/' \
              "$MC_CONF/mc.keymap"
    run sed -i -E 's/^(WordLeft = ctrl-left)(; ctrl-z)$/\1/' \
              "$MC_CONF/mc.keymap"
    run sed -i -E 's/^(WordRight = ctrl-right)(; ctrl-x)$/\1/' \
              "$MC_CONF/mc.keymap"

    run cp -f "${pkgs.mc}/etc/mc/mc.menu" "$MC_CONF/menu"
    run chmod ug+w "$MC_CONF/menu"

    if ! grep 'Compress the current subdirectory (zip)' "$MC_CONF/menu" \
       &>/dev/null
    then
    run sed -i -E 's/^( ?)(\s*)echo "\.\.\/\$tar\.tar\.lzo created\."$/&\
    \
    9\2Compress the current subdirectory (zip)\
    \1\2Pwd=`basename %d \/`\
    \1\2echo -n "Name of the compressed file (without extension) [$Pwd]: "\
    \1\2read zip\
    \1\2[ "$zip"x = x ] \&\& zip="$Pwd"\
    \1\2cd .. \&\& \\\
    \1\2zip -r "$Pwd" "$Pwd" \&\& \\\
    \1\2echo "..\/$zip.zip created."/' "$MC_CONF/menu"
    fi
  '';
}
