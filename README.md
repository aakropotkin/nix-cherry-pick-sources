# nix-cherry-pick-sources
A trivial example of cherry picking source files in a derivation.

A simple `preUnpack` is used, allowing regular files to be "unpacked" into a source root.
Files will be copied to `sourceRoot` if it has been set ( likely in the derivation itself, or perhaps an earlier setup-hook ), but if none is given a directory matching the derivation name will be created, filled with files, and be set as `sourceRoot` before the `unpackPhase` attempts to derive it.

Note that setting `sourceRoot` explicitly is necessary to avoid Nix complaining about multiple directories being created.

Also note that you almost certainly don't want to list a tarball under `srcs` if you plan to use `unpackByCopy` - since it WILL NOT cause tarballs to be copied. Rather Nix's existing `unpackCmdHooks` list will catch tarballs using `_defaultUnpackCmd` which will unzip them under `TMPDIR`. If you do really want to copy tarballs without unzipping them, you could do `unpackCmdHooks=( unpackByCopy )` rather than appending the list of hooks - but you'll obviously lose any other magic unpacking commands that you usually rely on.

### What it allows us to do
Rather than filtering the source directory down using something like `nix-gitignore`, instead we can simply name source files we want explicitly. For example, the `srcs` list below will produce a source root containing just those two files. This cherry picking style as opposed to something like `src = ./.;` eliminates rebuilds resulting from checksum changes on files which have no "real" effect on package outputs' behavior/content.

```nix
stdenv.mkDerivation {
  /* ... */
  srcs = [
    ./Makefile
    ./configure
  ];
}
```

### Running the example
Assuming you have `nix` installed, and the `nixpkgs` channel in your `NIX_PATH`:

```sh
nix-build;
cat result/msg;
rm result;
```

### Results
The contents of the `msg` file in our derivation look like this ( well at least until I update this repo and forget to update the README.md ):

```
Howdy

$ ls
Makefile
cfg.mk
configure
msg

$ ls../*
../env-vars

../sources-test:
baz

../sources-test-1.0.0-source:
Makefile
cfg.mk
configure
msg
```
