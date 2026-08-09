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

### Overriding Packages (e.g., for older/newer GPUs)

> **Breaking change:** the `EXTRA_REQUIREMENTS` environment variable has been
> replaced by `UV_OVERRIDE`. The old variable is silently ignored. Reason:
> `EXTRA_REQUIREMENTS` was installed as a second step *after* the main
> requirements, so every container start first restored the stock pins
> (multi-GB torch download) and then reverted them back — twice the traffic
> on every start. `UV_OVERRIDE` replaces the pins during resolution instead,
> so packages are installed once and further starts change nothing.

If you need to override packages (like PyTorch for a GPU the default build
does not support), you have two options:

#### Option 1: Using an override file (recommended for PyTorch)

1. Copy [`user_requirements.txt.example`](user_requirements.txt.example) into
   your data volume as `user_requirements.txt` and uncomment the section you
   need (there are examples for GTX 10xx / RTX 50xx / CPU-only inside).

2. Run the container with two environment variables — `UV_OVERRIDE` is the
   path to the file **inside the container**, `UV_EXTRA_INDEX_URL` points to
   the PyTorch wheel index matching your CUDA build:
   ```bash
   docker run \
     -v $(pwd)/data:/data \
     -e UV_OVERRIDE=/data/user_requirements.txt \
     -e UV_EXTRA_INDEX_URL=https://download.pytorch.org/whl/cu126 \
     -p 7860:7860 \
     ghcr.io/alertua/patriotyk_styletts2_ukrainian_docker:latest
   ```

Every version pin in the file overrides the corresponding pin in
`requirements.txt`. If the file is missing, the container logs a warning and
starts with stock versions.

#### Option 2: Using environment variable (simple packages only)

```bash
docker run \
  -e EXTRA_PACKAGES="some-package==1.2.3" \
  ...
```

> **Note:** `EXTRA_PACKAGES` is installed as an extra step and can conflict
> with the stock pins — for PyTorch always use Option 1.

### uv cache (`UV_CACHE_DIR`)

`UV_CACHE_DIR` is the uv download cache directory **inside the container**.
It defaults to `/data/uv_cache`, i.e. it lives in the data volume and
survives container re-creation — no extra configuration needed.

To share one uv cache between several containers/projects, bind a host
directory over the default location:

```yaml
    volumes:
      - /path/to/shared/uv_cache:/data/uv_cache
```
