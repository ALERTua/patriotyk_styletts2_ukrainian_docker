[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner-direct-single.svg)](https://stand-with-ukraine.pp.ua)
[![Made in Ukraine](https://img.shields.io/badge/made_in-Ukraine-ffd700.svg?labelColor=0057b7)](https://stand-with-ukraine.pp.ua)
[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://stand-with-ukraine.pp.ua)
[![Russian Warship Go Fuck Yourself](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/RussianWarship.svg)](https://stand-with-ukraine.pp.ua)


## Docker container for patriotyk/styletts2_ukrainian Gradio app

Repository: https://github.com/ALERTua/patriotyk_styletts2_ukrainian_docker

GitHub Docker Registry: https://github.com/ALERTua/patriotyk_styletts2_ukrainian_docker/pkgs/container/patriotyk_styletts2_ukrainian_docker

Docker Hub: https://hub.docker.com/r/alertua/patriotyk_styletts2_ukrainian_docker


### Description

Docker image for the [patriotyk/styletts2-ukrainian](https://huggingface.co/spaces/patriotyk/styletts2-ukrainian) gradio app.

Used with https://github.com/ALERTua/styletts2-ukrainian-openai-tts-api to provide an OpenAI TTS API endpoint to use it with Home Assistant.


### Deployment

The best way is to use the [docker-compose.yml](https://github.com/ALERTua/styletts2-ukrainian-openai-tts-api/blob/main/docker-compose.yml)


#### Gradio Web UI

You can access the Gradio Web UI at http://{container_ip}:$GRADIO_SERVER_PORT


### Data volume structure
After the first run the data directory will look like this:

- `.cache` - Stressify and download cache. ~188mb
- `onnx` - contains ONNX verbalization models downloaded from HuggingFace Hub. ~4.5gb


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
