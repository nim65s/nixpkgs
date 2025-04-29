{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  torch
}:

let
  # https://github.com/open-mmlab/mmdetection/blob/main/docs/en/notes/faq.md#installation
  mmcv-210 = mmcv.overrideAttrs rec {
    version = "2.1.0";
    src = fetchFromGitHub {
      owner = "open-mmlab";
      repo = "mmcv";
      tag = "v${version}";
      hash = "sha256-an78tRvx18zQ5Q0ca74r4Oe2gJ9F9OfWXLbuP2+rL68=";
    };
  };
in
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
    mmcv-210
    numpy
    pycocotools
    scipy
    shapely
    six
    terminaltables
    tqdm
    torch
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
      mmcv-210
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

  doCheck = pythonOlder "3.11"; # asynctest is unsupported on python3.11

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
