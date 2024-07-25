{
  pkgs,
  lib,
}: {
  setupMcWrapper = lib.hm.dag.entryAfter ["writeBoundary"] ''
    readonly BARC=/etc/bash.bashrc
    if ! grep 'alias.*mc=' $BARC \
       &>/dev/null
    then
      # if [ "$(tail -c 1 $BARC | xxd -p)" != "0a" ]; then
      # if [ "$(tail -c 1 $BARC | wc -l)" -ne 1 ]; then
      if (( "$(tail -c 1 $BARC | wc -l)" < 1 )); then
        run echo >> $BARC
      fi

      run echo -e "\nalias mc='. ${pkgs.mc}/libexec/mc/mc-wrapper.sh'" >> $BARC
    fi
  '';
}
