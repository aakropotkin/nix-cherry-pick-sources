{ mkDerivation ? ( import <nixpkgs> {} ).stdenv.mkDerivation
}:
mkDerivation rec {
  pname   = "sources-test";
  version = "1.0.0";
  srcs = [
    ./Makefile
    ./configure
  ];
  preUnpack = ''
    function unpackByCopy () {
      local fn="$1";
      local srcRoot="''${sourceRoot:-${pname}-${version}}";
      test -d $srcRoot || mkdir -p $srcRoot;
      cp -p --reflink=auto -- "$fn" "$srcRoot/$( stripHash $fn; )";
    }
    unpackCmdHooks+=( unpackByCopy );
  '';
  preBuild = ''
    makeFlagsArray+=( prefix="$out" );
  '';
}
