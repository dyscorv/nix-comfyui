{ basePython }:

{
  python = "==${basePython.version}";

  addict = "*";
  aiohttp = "*";
  albumentations = "*";
  einops = "*";
  filelock = "*";
  ftfy = "*";
  fvcore = "*";
  huggingface-hub = "*";
  importlib-metadata = "*";
  insightface = "*";
  kornia = ">=0.7.1";
  mediapipe = "*";
  numpy = "*";
  omegaconf = "*";
  onnxruntime = "*";
  opencv-python = "==4.7.0.72";
  pillow = "*";
  psutil = "*";
  python-dateutil = "*";
  pyyaml = "*";
  safetensors = ">=0.4.2";
  scikit-image = "*";
  scikit-learn = "*";
  scipy = "*";
  soundfile = "*";
  spandrel = "*";
  spandrel-extra-arches = "*";
  svglib = "*";
  torch = "*";
  torchaudio = "*";
  torchsde = "*";
  torchvision = "*";
  tqdm = "*";
  transformers = ">=4.25.1";
  trimesh = "*";
  yacs = "*";
  yapf = "*";
}
