{ basePython, content, emptyPyproject, lib }:

let
  finalContent = lib.recursiveUpdate
    {
      tool.poetry.name = "comfyui-environment";

      tool.poetry.dependencies = {
        python = "==${basePython.version}";

        accelerate = "*";
        addict = "*";
        aiohttp = "*";
        albumentations = "*";
        argostranslate = "*";
        colour-science = "*";
        diffusers = "*";
        einops = "*";
        filelock = "*";
        ftfy = "*";
        fvcore = "*";
        huggingface-hub = "*";
        importlib-metadata = "*";
        insightface = "*";
        kornia = "*";
        mediapipe = "*";
        numba = "*";
        numexpr = "*";
        numpy = "*";
        omegaconf = "*";
        onnx = "*";
        onnxruntime = "*";
        open-clip-torch = "*";
        opencv-python = "==4.7.0.72";
        packaging = "*";
        pandas = "*";
        pillow = "*";
        pixeloe = "*";
        psutil = "*";
        python-dateutil = "*";
        pytorch-lightning = "*";
        pyyaml = "*";
        rembg = "*";
        requests = "*";
        safetensors = "*";
        scikit-image = "*";
        scikit-learn = "*";
        scipy = "*";
        segment-anything = "*";
        sentencepiece = "*";
        soundfile = "*";
        spandrel = "*";
        spandrel-extra-arches = "*";
        svglib = "*";
        tokenizers = "*";
        torchsde = "*";
        tqdm = "*";
        transformers = "*";
        transparent-background = "*";
        trimesh = "*";
        typing-extensions = "*";
        ultralytics = "*";
        yacs = "*";
        yapf = "*";
      };
    }
    content;
in

emptyPyproject.override {
  content = finalContent;
}
