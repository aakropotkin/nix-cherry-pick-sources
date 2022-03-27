{ mkDerivation ? ( import <nixpkgs> {} ).stdenv.mkDerivation
}:
mkDerivation rec {
  pname   = "sources-test";
  version = "1.0.0";
  srcs = [
    ./Makefile
    ./configure
    ./sources-test.tar.gz
  ];

  preUnpack = ''
    sourceRoot="''${sourceRoot:-${pname}-${version}-source}"
    export sourceRoot
    function unpackByCopy () {
      local fn="$1"
      # Only copy regular files
      test -d "$fn" && return
      test -d $sourceRoot || mkdir -p $sourceRoot
      cp -p --reflink=auto -- "$fn" "$sourceRoot/$( stripHash $fn )"
    }
    unpackCmdHooks+=( unpackByCopy )
  '';

  preBuild = ''
    makeFlagsArray+=( prefix="$out" )
  '';
}
