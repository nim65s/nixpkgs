{
  gdb,
  fetchFromGitHub
}:

# can't use fetchSubmodules, as one is pointing to a non-existent commit
let
  esp-toolchain-bin-wrappers = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-toolchain-bin-wrappers";
    rev = "62776e937e4fb6e9d0ff6081a5ca9571b210f7ba";
    hash = "sha256-DsfYQMYmcEVdTzoaOHUjGynXaxCE00Rcm2rby8Y94jw=";
  };
  xtensa-dynconfig = fetchFromGitHub {
    owner = "espressif";
    repo = "xtensa-dynconfig";
    rev = "905b913aa65638be53ac22029c379fa16dab31db";
    hash = "sha256-QCWSo3fmr0g/dDYz81i/fttlDgGCAwcBtIMWTVg1ufg=";
  };
  xtensa-overlays = fetchFromGitHub {
    owner = "espressif";
    repo = "xtensa-overlays";
    rev = "dd1cf19f6eb327a9db51043439974a6de13f5c7f";
    hash = "sha256-guFWS6QAjJ1Z2u2YOIha97EaBGLThWRz6kjrPSf0y9M=";
  };
in
gdb.overrideAttrs (prevAttrs: rec {
  pname = "xtensa-esp-elf-gdb";
  version = "14.2_20240403";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "binutils-gdb";
    rev = "esp-gdb-v${version}";
    hash = "sha256-qsa4fDojtT+8lYIMRqZ6tBS8iboXIdxz/zBy6dr2XQc=";
  };

  postPatch = (prevAttrs.postPatch or "") + ''
    # git submodules
    ln -s ${esp-toolchain-bin-wrappers} esp-toolchain-bin-wrappers
    ln -s ${xtensa-dynconfig} xtensa-dynconfig
    ln -s ${xtensa-overlays} xtensa-overlays
  '';

  # can't remove already removed precompiled docs
  # so copy/paste prevAttrs.preConfigure, without 'rm gdb/doc' stuff
  preConfigure = ''
    # GDB have to be built out of tree.
    mkdir _build
    cd _build
  '';
})
