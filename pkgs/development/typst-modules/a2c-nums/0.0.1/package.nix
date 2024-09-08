{ stdenvNoCC, typst-packages }:
stdenvNoCC.mkDerivation {
  pname = "a2c-nums";
  version = "0.0.1";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/share/typst/packages/preview/a2c-nums/0.0.1
    cp -r ${typst-packages.src}/packages/preview/a2c-nums/0.0.1 $out/share/typst/packages/preview/a2c-nums
  '';
}
