{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  einops,
  importlib-metadata,
  mat4py,
  matplotlib,
  modelindex,
  numpy,
  rich,
  albumentations,
  coverage,
  grad-cam,
  interrogate,
  pytest,
  requests,
  scikit-learn,
  mmcv,
  mmengine,
  pycocotools,
  transformers,
}:

buildPythonPackage rec {
  pname = "mmpretrain";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = "mmpretrain";
    rev = "v${version}";
    hash = "sha256-3aEEtfhK7hpzJ/rM7yb2MNRh7J85RWD05ppgOURQb04=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    einops
    importlib-metadata
    mat4py
    matplotlib
    modelindex
    numpy
    rich
  ];

  optional-dependencies = {
    all = [
      albumentations
      coverage
      einops
      grad-cam
      importlib-metadata
      interrogate
      mat4py
      matplotlib
      modelindex
      numpy
      pytest
      requests
      rich
      scikit-learn
    ];
    mim = [
      mmcv
      mmengine
    ];
    multimodal = [
      pycocotools
      transformers
    ];
    optional = [
      albumentations
      grad-cam
      requests
      scikit-learn
    ];
    tests = [
      coverage
      interrogate
      pytest
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.tests;

  doCheck = true;

  pythonImportsCheck = [
    "mmpretrain"
  ];

  meta = {
    description = "OpenMMLab Pre-training Toolbox and Benchmark";
    homepage = "https://github.com/open-mmlab/mmpretrain";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
