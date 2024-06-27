{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  eigen,
  example-robot-data,
  collisionSupport ? true,
  console-bridge,
  jrl-cmakemodules,
  coal,
  urdfdom,
  pythonSupport ? false,
  python3Packages,
}:

stdenv.mkDerivation (_finalAttrs: {
  pname = "pinocchio";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "pinocchio";
    #rev = "v${finalAttrs.version}";
    rev = "43d91447a2b181cdd6f40440d07f7769ab4da88e";
    hash = "sha256-MdJBZhvYTAF50vM1jZzv60/eGZeV/klSRa2BzOhr+Os=";
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

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs =
    [
      console-bridge
      jrl-cmakemodules
      urdfdom
    ]
    ++ lib.optionals (!pythonSupport) [
      boost
      eigen
    ]
    ++ lib.optionals (!pythonSupport && collisionSupport) [ coal ]
    ++ lib.optionals pythonSupport [
      python3Packages.boost
      python3Packages.eigenpy
    ]
    ++ lib.optionals (pythonSupport && collisionSupport) [ python3Packages.coal ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_LIBPYTHON" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_COLLISION_SUPPORT" collisionSupport)
  ];

  doCheck = true;

  pythonImportsCheck = lib.optionals (!pythonSupport) [ "pinocchio" ];

  meta = {
    description = "Fast and flexible implementation of Rigid Body Dynamics algorithms and their analytical derivatives";
    homepage = "https://github.com/stack-of-tasks/pinocchio";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      nim65s
      wegank
    ];
    platforms = lib.platforms.unix;
  };
})
