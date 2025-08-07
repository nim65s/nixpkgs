{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vid.stab";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "georgmartius";
    repo = "vid.stab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p1VRnkBeUpET3O2FmaJMyN5/EoSOQLdmRIVbzZcQaKY=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required (VERSION 2.8.5)" \
      "cmake_minimum_required (VERSION 3.5)"
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = lib.optionals stdenv.cc.isClang [ openmp ];

  meta = {
    description = "Video stabilization library";
    homepage = "http://public.hronopik.de/vid.stab/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ codyopel ];
    platforms = lib.platforms.all;
  };
})
