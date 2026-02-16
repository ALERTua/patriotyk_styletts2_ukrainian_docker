[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner-direct-single.svg)](https://stand-with-ukraine.pp.ua)
[![Made in Ukraine](https://img.shields.io/badge/made_in-Ukraine-ffd700.svg?labelColor=0057b7)](https://stand-with-ukraine.pp.ua)
[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://stand-with-ukraine.pp.ua)
[![Russian Warship Go Fuck Yourself](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/RussianWarship.svg)](https://stand-with-ukraine.pp.ua)


## Docker container for patriotyk/styletts2_ukrainian Gradio app

Repository: https://github.com/ALERTua/patriotyk_styletts2_ukrainian_docker

GitHub Docker Registry: https://github.com/ALERTua/patriotyk_styletts2_ukrainian_docker/pkgs/container/patriotyk_styletts2_ukrainian_docker


### Description

Docker image for the [patriotyk/styletts2-ukrainian](https://huggingface.co/spaces/patriotyk/styletts2-ukrainian) gradio app.

Used with https://github.com/ALERTua/styletts2-ukrainian-openai-tts-api to provide an OpenAI TTS API endpoint to use it with Home Assistant.


### Deployment

The best way is to use the [docker-compose.yml](https://github.com/ALERTua/styletts2-ukrainian-openai-tts-api/blob/main/docker-compose.yml)


#### Gradio Web UI

You can access the Gradio Web UI at http://{container_ip}:$GRADIO_SERVER_PORT


### Data volume structure
After the first run the `/data` directory will look like this:

- `.cache` - Huggingface models download cache. ~8GB
- `stanza` - tokenizer download cache. ~200MB
- `uv_cache` - cache for installing prerequisites ~6.2gb
- `venv` - working environment ~6.2gb


### Resources usage
- tag `latest` uses ~6 GiB of RAM


### Things to do that I have no knowledge on (help appreciated)

- [ ] Make this use less RAM
- [ ] Make this correctly support mp3 response format
- [x] Make this pronounce numbers


### Things to do that depend on the author's code

- [ ] Dynamic model loading depending on an environment variable
- [ ] Dynamic verbalization model loading depending on an environment variable
- [ ] A separate endpoint that lists all voices


### Caveats

- The first start is slow as the models are downloaded.
- The original code does not print anything in the log while doing that, so it looks like it's stuck.

### Overriding Packages (e.g., for newer GPUs)

If you need to override packages (like PyTorch for newer GPU support), you have two options:

#### Option 1: Using a requirements file (recommended for PyTorch)

1. Copy the example file:
   ```bash
   cp user_requirements.txt.example user_requirements.txt
   ```

2. Edit `user_requirements.txt` to your needs (uncomment the appropriate section)

3. Run the container:
   ```bash
   docker run \
     -v $(pwd)/user_requirements.txt:/app/user_requirements.txt \
     -e EXTRA_REQUIREMENTS=/app/user_requirements.txt \
     -p 7860:7860 \
     ghcr.io/alertua/patriotyk_styletts2_ukrainian_docker:latest
   ```

#### Option 2: Using environment variable (simple packages only)

```bash
docker run \
  -e EXTRA_PACKAGES="torch==2.3.1 --index-url https://download.pytorch.org/whl/cu121" \
  ...
```

> **Note:** For PyTorch with custom index URLs, use Option 1 (requirements file) as it properly supports the `--index-url` directive.

#### RTX 5070 Example

RTX 5070 (Blackwell architecture) requires PyTorch 2.5+ with CUDA 12.4:

1. Create `user_requirements.txt`:
   ```txt
   --index-url https://download.pytorch.org/whl/cu124
   torch==2.5.1
   torchaudio
   ```

2. Run with GPU support:
   ```bash
   docker run --gpus all \
     -v $(pwd)/user_requirements.txt:/app/user_requirements.txt \
     -e EXTRA_REQUIREMENTS=/app/user_requirements.txt \
     ...
   ```

See [`user_requirements.txt.example`](user_requirements.txt.example) for more examples.
