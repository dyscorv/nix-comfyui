{ basePython, content, emptyPyproject, lib }:

let
  finalContent = lib.recursiveUpdate
    {
      tool.poetry.name = "comfyui-environment";

      tool.poetry.dependencies = {
        python = "==${basePython.version}";

        addict = "*";
        aiohttp = "*";
        albumentations = "*";
        argostranslate = "*";
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
        numexpr = "*";
        numpy = "*";
        omegaconf = "*";
        onnx = "*";
        onnxruntime = "*";
        opencv-python = "==4.7.0.72";
        packaging = "*";
        pandas = "*";
        pillow = "*";
        psutil = "*";
        python-dateutil = "*";
        pyyaml = "*";
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
