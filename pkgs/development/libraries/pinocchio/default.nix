{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, example-robot-data
, collisionSupport ? true
, console-bridge
, jrl-cmakemodules
, hpp-fcl
, urdfdom
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation (_finalAttrs: {
  pname = "pinocchio";
  version = "3.1.0";

  src = fetchFromGitHub {
    #owner = "stack-of-tasks";
    owner = "nim65s";
    repo = "pinocchio";
    #rev = "v${finalAttrs.version}";
    rev = "65657a335d09fc0407f68296a99cfc6f03788bc5";
    hash = "sha256-5DwUNvYokZ+EBaz1twySt0OREvxn6gmzIN/j+qlZziI=";
  };

  # test failure, ref https://github.com/stack-of-tasks/pinocchio/issues/2277
  prePatch = lib.optionalString (stdenv.isLinux && stdenv.isAarch64) ''
    substituteInPlace unittest/algorithm/utils/CMakeLists.txt \
      --replace-fail "add_pinocchio_unit_test(force)" ""
  '';

  # example-robot-data models are used in checks.
  # Upstream provide them as git submodule, but we can use our own version instead.
  postPatch = ''
    rmdir models/example-robot-data
    ln -s ${example-robot-data.src} models/example-robot-data
  '';

  # CMAKE_BUILD_TYPE defaults to Release in this package,
  # which enable -O3, which break some tests
  # ref. https://github.com/stack-of-tasks/pinocchio/issues/2304#issuecomment-2231018300
  postConfigure = ''
    substituteInPlace CMakeCache.txt --replace-fail '-O3' '-O2'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    console-bridge
    jrl-cmakemodules
    urdfdom
  ] ++ lib.optionals (!pythonSupport) [
    boost
    eigen
  ] ++ lib.optionals (!pythonSupport && collisionSupport) [
    hpp-fcl
  ] ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
  ] ++ lib.optionals (pythonSupport && collisionSupport) [
    python3Packages.hpp-fcl
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_LIBPYTHON" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_COLLISION_SUPPORT" collisionSupport)
  ];

  doCheck = true;

  pythonImportsCheck = lib.optionals (!pythonSupport) [
    "pinocchio"
  ];

  meta = {
    description = "Fast and flexible implementation of Rigid Body Dynamics algorithms and their analytical derivatives";
    homepage = "https://github.com/stack-of-tasks/pinocchio";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s wegank ];
    platforms = lib.platforms.unix;
  };
})
