{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  boost,
  eigen,
  assimp,
  jrl-cmakemodules,
  octomap,
  qhull,
  pythonSupport ? false,
  python3Packages,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-fcl";
  version = "3.0.0-pre";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-fcl";
    #rev = "v${finalAttrs.version}";
    rev = "eaa94d6";
    hash = "sha256-WOXqSmW7NZ4vsiE1SytbZjqvpKX7gCJVDrmX/mBVxlQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ] ++ lib.optionals pythonSupport [ python3Packages.numpy ];

  propagatedBuildInputs =
    [
      assimp
      jrl-cmakemodules
      qhull
      octomap
      zlib
    ]
    ++ lib.optionals (!pythonSupport) [
      boost
      eigen
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.boost
      python3Packages.eigenpy
    ];

  cmakeFlags = [
    "-DCOAL_BACKWARD_COMPATIBILITY_WITH_HPP_FCL=ON"
    "-DCOAL_HAS_QHULL=ON"
    "-DINSTALL_DOCUMENTATION=ON"
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;
  pythonImportsCheck = lib.optionals (!pythonSupport) [ "hppfcl" ];

  outputs = [
    "dev"
    "out"
    "doc"
  ];
  postFixup = ''
    moveToOutput share/ament_index "$dev"
    moveToOutput share/${finalAttrs.pname} "$dev"
  '';

  meta = {
    description = "Extension of the Flexible Collision Library";
    homepage = "https://github.com/humanoid-path-planner/hpp-fcl";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
