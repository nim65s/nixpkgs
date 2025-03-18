{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  attrs,
  click,
  colorama,
  py,
  tabulate,
  tomli,
  cairosvg,
  coverage,
  pre-commit,
  pytest,
  pytest-cov,
  pytest-mock,
  sphinx,
  sphinx-autobuild,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "interrogate";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oyDW7GRN/Yh8xYJHo0UFT8TZ+YEQDEUYRHAGj0s3GbA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    attrs
    click
    colorama
    py
    tabulate
    tomli
  ];

  optional-dependencies = {
    dev = [
      pre-commit
    ];
    docs = [
      sphinx
      sphinx-autobuild
    ];
    png = [
      cairosvg
    ];
    tests = [
      coverage
      pytest
      pytest-cov
      pytest-mock
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.tests;

  pythonImportsCheck = [
    "interrogate"
  ];

  meta = {
    description = "Interrogate a codebase for docstring coverage";
    homepage = "https://github.com/econchick/interrogate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
