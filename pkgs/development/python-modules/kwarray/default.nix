{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  pytestCheckHook,
  numpy,
  packaging,
  ubelt,
  coverage,
  nptyping,
  pandas,
  pytest,
  pytest-cov,
  scipy,
  torch,
  xdoctest,
  kwplot,
  myst-parser,
  pygments,
  sphinx,
  sphinx-autoapi,
  sphinx-autobuild,
  sphinx-reredirects,
  sphinx-rtd-theme,
  sphinxcontrib-napoleon,
  flake8,
}:

buildPythonPackage rec {
  pname = "kwarray";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner = "computer-vision";
    repo = "kwarray";
    rev = "v${version}";
    hash = "sha256-4Qg+wQ+I3PczlNl9WTMU5W8VRbxNSo8T29CkA4nAz+M=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    packaging
    ubelt
  ];

  optional-dependencies = {
    all = [
      coverage
      nptyping
      numpy
      packaging
      pandas
      pytest
      pytest-cov
      scipy
      torch
      ubelt
      xdoctest
    ];
    all-strict = [
      coverage
      nptyping
      numpy
      packaging
      pandas
      pytest
      pytest-cov
      scipy
      torch
      ubelt
      xdoctest
    ];
    docs = [
      kwplot
      myst-parser
      pygments
      sphinx
      sphinx-autoapi
      sphinx-autobuild
      sphinx-reredirects
      sphinx-rtd-theme
      sphinxcontrib-napoleon
      xdoctest
    ];
    docs-strict = [
      kwplot
      myst-parser
      pygments
      sphinx
      sphinx-autoapi
      sphinx-autobuild
      sphinx-reredirects
      sphinx-rtd-theme
      sphinxcontrib-napoleon
      xdoctest
    ];
    linting = [
      flake8
    ];
    linting-strict = [
      flake8
    ];
    optional = [
      nptyping
      pandas
      scipy
      torch
    ];
    optional-strict = [
      nptyping
      pandas
      scipy
      torch
    ];
    runtime = [
      numpy
      packaging
      ubelt
    ];
    runtime-strict = [
      numpy
      packaging
      ubelt
    ];
    tests = [
      coverage
      packaging
      pytest
      pytest-cov
      xdoctest
    ];
    tests-strict = [
      coverage
      packaging
      pytest
      pytest-cov
      xdoctest
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.tests;

  doCheck = true;

  pythonImportsCheck = [
    "kwarray"
  ];

  meta = {
    description = "Python utilities and common algorithms for operating on arrays";
    homepage = "https://gitlab.kitware.com/computer-vision/kwarray";
    changelog = "https://gitlab.kitware.com/computer-vision/kwarray/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
