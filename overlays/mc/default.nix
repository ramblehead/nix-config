{ pkgs, inputs, ... }: {
  overlay = final: prev: {
    mc = prev.mc.overrideAttrs (prevAttrs: {
      preConfigure = ''
        cp ${inputs.overlay-mc}/nix.syntax misc/syntax/nix.syntax
  
        sed -i -e "s|yxx.syntax|yxx.syntax nix.syntax|" misc/syntax/Makefile.am
  
        sed -i -e '/unknown$/i \
        file ..\\*\\\\.nix$ Nix\\sExpression\
        include nix.syntax\
        ' misc/syntax/Syntax.in
  
        autoreconf -f -v -i
      '';
  
      buildInputs = prevAttrs.buildInputs ++ (with pkgs; [
        pkgs.autoconf
        pkgs.automake
        pkgs.libtool
      ]);
    });
  };
}
