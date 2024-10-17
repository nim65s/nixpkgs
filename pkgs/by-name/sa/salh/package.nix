{ fetchurl, lib, stdenvNoCC }:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "salh";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/dotnet/corert/master/src/Native/inc/unix/sal.h";
    hash = "sha256-u56nwdBc38EKF/6A2Hp80WDBBjx+X6CJzWQFwxxhChs=";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm444 ${finalAttrs.src} $out/include/sal.h
  '';

  meta = {
    description = "open source sal.h header to build microsoft things on non-windows platforms";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
