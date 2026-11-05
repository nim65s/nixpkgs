{
  lib,

  buildPythonPackage,
  fetchFromGitHub,
  fontconfig,
  stdenv,

  # nativeBuildInputs
  scipy,

  # buildInputs
  boost,
  jrl-cmakemodules,
  suitesparse,

  # propagatedBuildInputs
  eigen,
  numpy,

  # options
  withCholmod ? false,
}:
buildPythonPackage (finalAttrs: {
  pname = "eigenpy";
  version = "3.13.0";
  # version = "3.14.0";
  pyproject = false; # Built with cmake

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "eigenpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-05G0U1RjVwggfnABxZH+9kxDIo7M9rgxHCcTvNgTZCQ=";
    # rev = "2acc35dbd7c3b9fd21b6368e381b5533160f493a";
    # hash = "sha256-4JxP6gZBYXQufl9VgiTAGl5dgNyng/qEE4Xhoz1OwLc=";
  };

  outputs = [
    "dev"
    "doc"
    "out"
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_TESTING_SCIPY" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_WITH_CHOLMOD_SUPPORT" withCholmod)
    (lib.cmakeBool "BUILD_WITH_ACCELERATE_SUPPORT" stdenv.hostPlatform.isDarwin)
    (lib.cmakeBool "GENERATE_PYTHON_STUBS" false)
    # (lib.cmakeBool "GENERATE_PYTHON_STUBS" true)
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    boost
    jrl-cmakemodules
  ]
  ++ lib.optional withCholmod suitesparse;

  propagatedBuildInputs = [
    eigen
    numpy
  ];

  pythonImportsCheck = [ "eigenpy" ];

  checkInputs = [
    scipy
  ];

  passthru = { inherit withCholmod; };

  meta = {
    description = "Bindings between Numpy and Eigen using Boost.Python";
    homepage = "https://github.com/stack-of-tasks/eigenpy";
    changelog = "https://github.com/stack-of-tasks/eigenpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      nim65s
      wegank
    ];
    platforms = lib.platforms.unix;
  };
})
