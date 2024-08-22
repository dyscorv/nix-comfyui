{ basePyproject, lib }:

basePyproject.override {
  content = {
    tool.poetry.dependencies = {
      pytorch-triton-rocm = { version = "*"; source = "torch-rocm"; };
      taichi = "*";
      torch = { version = "~2.3.0+rocm6.0"; source = "torch-rocm"; };
      torchaudio = { version = "*"; source = "torch-rocm"; };
      torchvision = { version = "*"; source = "torch-rocm"; };
    };

    tool.poetry.source = lib.singleton {
      name = "torch-rocm";
      url = "https://download.pytorch.org/whl/rocm6.0";
      priority = "explicit";
    };
  };
}
