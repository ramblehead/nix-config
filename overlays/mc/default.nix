final: prev: {
  mc = prev.mc.overrideAttrs (prevAttrs: let path = ./.; in {
    preConfigure = ''
      cp ${path}/nix.syntax misc/syntax/nix.syntax

      sed -i -e "s|yxx.syntax|yxx.syntax nix.syntax|" misc/syntax/Makefile.am

      sed -i -e '/unknown$/i \
      file ..\\*\\\\.nix$ Nix\\sExpression\
      include nix.syntax\
      ' misc/syntax/Syntax.in

      autoreconf -f -v -i
    '';

    buildInputs = prevAttrs.buildInputs ++ (with prev; [
      autoconf
      automake
      libtool
    ]);
  });
}
