# nix-comfyui

ComfyUI as a Nix expression. Give it a try:

```sh
# ComfyUI is patched to keep models and other runtime data in $PWD.
mkdir comfyui && cd comfyui
nix run github:dyscorv/nix-comfyui#comfyui-with-extensions
```

Then setup and run Krita with ComfyUI integration:

```sh
# Change to the same directory in another terminal window.
cd comfyui
# Download the models required by "Generative AI for Krita".
nix run github:dyscorv/nix-comfyui#krita-ai-diffusion -- --no-sdxl --verbose .
# Run Krita with ComfyUI integration.
nix run github:dyscorv/nix-comfyui#krita-with-extensions
```
