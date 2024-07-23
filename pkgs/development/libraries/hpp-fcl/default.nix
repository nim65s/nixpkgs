{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, boost
, eigen
, assimp
, jrl-cmakemodules
, octomap
, qhull
, pythonSupport ? false
, python3Packages
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-fcl";
  version = "3.0.0";

  src = fetchFromGitHub {
    #owner = "humanoid-path-planner";
    owner = "nim65s";
    repo = "hpp-fcl";
    #rev = "v${finalAttrs.version}";
    rev = "dc1105eb092c03eeb52d3655638f013dfe0426da";
    hash = "sha256-pAqP65pBYI9mJdfwj8r8eaj2vg+2DSi9aUX6+f2yI14=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  propagatedBuildInputs = [
    assimp
    jrl-cmakemodules
    qhull
    octomap
    zlib
  ] ++ lib.optionals (!pythonSupport) [
    boost
    eigen
  ] ++ lib.optionals pythonSupport [
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
  pythonImportsCheck = lib.optionals (!pythonSupport) [
    "hppfcl"
  ];

  outputs = [ "dev" "out" "doc" ];
  postFixup = ''
    moveToOutput share/ament_index "$dev"
    moveToOutput share/${finalAttrs.pname} "$dev"
  '';


  meta = with lib; {
    description = "Extension of the Flexible Collision Library";
    homepage = "https://github.com/humanoid-path-planner/hpp-fcl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nim65s ];
    platforms = platforms.unix;
  };
})
