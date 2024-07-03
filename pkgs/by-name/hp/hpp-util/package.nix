{
  fetchFromGitHub,
  lib,
  stdenv,
  boost,
  cmake,
  jrl-cmakemodules,
  tinyxml-2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-util";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-util";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cYONa7WTagNZCITtocdII+WcfdzZnvznFUyb7YLodIw=";
  };

  prePatch = ''
    substituteInPlace tests/run_debug.sh.in \
      --replace-fail /bin/bash ${stdenv.shell}
  '';

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    boost
    jrl-cmakemodules
    tinyxml-2
  ];

  doCheck = true;

  meta = {
    description = "Debugging tools for the HPP project";
    homepage = "https://github.com/humanoid-path-planner/hpp-util";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
