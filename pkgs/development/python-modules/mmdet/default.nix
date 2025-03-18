{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  matplotlib,
  numpy,
  pycocotools,
  scipy,
  shapely,
  six,
  terminaltables,
  tqdm,
  cityscapes-scripts,
  cython,
  emoji,
  fairscale,
  imagecorruptions,
  scikit-learn,
  mmcv,
  mmengine,
  jsonlines,
  nltk,
  pycocoevalcap,
  transformers,
  asynctest,
  codecov,
  flake8,
  #instaboostfast,  no license
  interrogate,
  isort,
  kwarray,
  memory-profiler,
  mmtrack,
  onnx,
  onnxruntime,
  parameterized,
  prettytable,
  protobuf,
  psutil,
  pytest,
  ubelt,
  xdoctest,
  yapf,
  mmpretrain,
  motmetrics,
  seaborn,
}:

buildPythonPackage rec {
  pname = "mmdet";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = "mmdetection";
    rev = "v${version}";
    hash = "sha256-0Dvd5wMREb+XBSZt1GH5FyWAidlfoVwuoF6espzWziI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    matplotlib
    numpy
    pycocotools
    scipy
    shapely
    six
    terminaltables
    tqdm
  ];

  optional-dependencies = {
    all = [
      cityscapes-scripts
      cython
      emoji
      fairscale
      imagecorruptions
      matplotlib
      numpy
      pycocotools
      scikit-learn
      scipy
      shapely
      six
      terminaltables
      tqdm
    ];
    build = [
      cython
      numpy
    ];
    mim = [
      mmcv
      mmengine
    ];
    multimodal = [
      fairscale
      jsonlines
      nltk
      pycocoevalcap
      transformers
    ];
    optional = [
      cityscapes-scripts
      emoji
      fairscale
      imagecorruptions
      scikit-learn
    ];
    tests = [
      asynctest
      cityscapes-scripts
      codecov
      flake8
      imagecorruptions
      #instaboostfast
      interrogate
      isort
      kwarray
      memory-profiler
      mmtrack
      nltk
      onnx
      onnxruntime
      parameterized
      prettytable
      protobuf
      psutil
      pytest
      transformers
      ubelt
      xdoctest
      yapf
    ];
    tracking = [
      mmpretrain
      motmetrics
      numpy
      scikit-learn
      seaborn
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.tests;

  doCheck = true;

  pythonImportsCheck = [
    "mmdet"
  ];

  meta = {
    description = "OpenMMLab Detection Toolbox and Benchmark";
    homepage = "https://github.com/open-mmlab/mmdetection";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
