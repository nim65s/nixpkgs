{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  libGL,
  libpng,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gte";
  version = "8.2";

  src = fetchFromGitHub {
    owner = "davideberly";
    repo = "GeometricTools";
    tag = "GTE-version-${finalAttrs.version}";
    hash = "sha256-OmWcD3T9OoLd7WDyqCyCLl5TeNnLBm9xV7DJxnb4hJc=";
  };

  sourceRoot = "source/GTE";

  postPatch = ''
    substituteInPlace Graphics/GL46/GL/glcorearb.h Graphics/GL46/GL/glext.h \
      --replace-fail "#include <KHR/khrplatform.h>" "#include <Graphics/GL46/GL/KHR/khrplatform.h>"
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libGL
    libpng
    libx11
  ];

  meta = {
    description = "A collection of source code for computing in the fields of mathematics, geometry, graphics, image analysis and physics.";
    homepage = "https://github.com/davideberly/GeometricTools";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      wishstudio
    ];
    platforms = lib.platforms.all;
  };
})
