{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  attributee,
  dotty-dict,
  lap,
  matplotlib,
  mmcls,
  motmetrics,
  packaging,
  pandas,
  pycocotools,
  scipy,
  seaborn,
  terminaltables,
  tqdm,
  asynctest,
  codecov,
  cython,
  flake8,
  interrogate,
  isort,
  kwarray,
  numpy,
  pytest,
  ubelt,
  xdoctest,
  yapf,
  mmcv-full,
  mmdet,
}:

buildPythonPackage rec {
  pname = "mmtrack";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = "mmtracking";
    rev = "v${version}";
    hash = "sha256-R6KzagZC2ZmqR0sC39MeN4ro/1bHBhQZuUHMF31ai+A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    attributee
    dotty-dict
    lap
    matplotlib
    mmcls
    motmetrics
    packaging
    pandas
    pycocotools
    scipy
    seaborn
    terminaltables
    tqdm
  ];

  optional-dependencies = {
    all = [
      asynctest
      attributee
      codecov
      cython
      dotty-dict
      flake8
      interrogate
      isort
      kwarray
      lap
      matplotlib
      mmcls
      motmetrics
      numpy
      packaging
      pandas
      pycocotools
      pytest
      scipy
      seaborn
      terminaltables
      tqdm
      ubelt
      xdoctest
      yapf
    ];
    build = [
      cython
      numpy
    ];
    mim = [
      mmcls
      mmcv-full
      mmdet
    ];
    tests = [
      asynctest
      codecov
      flake8
      interrogate
      isort
      kwarray
      pytest
      ubelt
      xdoctest
      yapf
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.tests;

  pythonImportsCheck = [
    "mmtrack"
  ];

  meta = {
    description = "OpenMMLab Unified Video Perception Platform";
    homepage = "https://pypi.org/project/mmtrack";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
