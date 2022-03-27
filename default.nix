{ stdenv ? ( import <nixpkgs> {} ).stdenv
}:
stdenv.mkDerivation rec {
  pname   = "sources-test";
  version = "1.0.0";
  srcs = [
    ./Makefile
    ./configure
    ./sources-test.tar.gz
  ];

  preUnpack = ''
    unpackCmdHooks+=( unpackByCopy )
    sourceRoot="''${sourceRoot:-${pname}-${version}-source}"
    # If a regular file is given in `srcs', clone it to `sourceDir'
    function unpackByCopy () {
      local fn="$1"
      # Only copy regular files
      test -d "$fn" && return
      test -d "$sourceRoot" || mkdir -p "$sourceRoot"
      cp -p --reflink=auto -- "$fn" "$sourceRoot/$( stripHash $fn )"
    }
  '';
}
