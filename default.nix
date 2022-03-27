{ stdenv   ? ( import <nixpkgs> {} ).stdenv,
  solution ? "better"
}:
let solutions = {
  better = stdenv.mkDerivation {
    pname   = "sources-test";
    version = "1.0.0";
    src = let
      pathsToKeep = map baseNameOf [
        ./Makefile
        ./configure
        ./sources-test.tar.gz
      ];
      filterFn = path: type: builtins.elem ( baseNameOf path ) pathsToKeep;
    in builtins.filterSource filterFn ./.;
  };

  works = stdenv.mkDerivation rec {
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
  };
};
in solutions.${solution}
