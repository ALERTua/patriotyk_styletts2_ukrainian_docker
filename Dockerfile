ARG PYTHON_VERSION=3.12

ARG APP_DIR=/usr/src/app
ARG UV_PROJECT_ENVIRONMENT=.venv
ARG UV_CACHE_DIR=.uv_cache
ARG SOURCE_DIR_NAME=styletts2-ukrainian


FROM ghcr.io/astral-sh/uv:python${PYTHON_VERSION}-trixie-slim AS builder

ARG UV_CACHE_DIR
ARG UV_PROJECT_ENVIRONMENT
ARG APP_DIR
ARG SOURCE_DIR_NAME

ENV \
    # uv
    UV_PYTHON_DOWNLOADS=0 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_FROZEN=1 \
    UV_NO_PROGRESS=true \
    UV_CACHE_DIR=$UV_CACHE_DIR \
    UV_PROJECT_ENVIRONMENT=$UV_PROJECT_ENVIRONMENT \
    # pip
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    # App
    APP_DIR=$APP_DIR \
    SOURCE_DIR_NAME=$SOURCE_DIR_NAME

WORKDIR $APP_DIR

RUN apt-get update \
    && apt-get install --no-install-recommends -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN \
    --mount=type=cache,target=$UV_CACHE_DIR \
    --mount=type=bind,source=$SOURCE_DIR_NAME/requirements.txt,target=requirements.txt \
    uv venv --no-project $UV_PROJECT_ENVIRONMENT \
    && uv pip install -r requirements.txt --no-config


FROM builder AS production

LABEL maintainer="ALERT <alexey.rubasheff@gmail.com>"

ARG SOURCE_DIR_NAME
ARG APP_DIR
ARG UV_PROJECT_ENVIRONMENT
ARG UV_CACHE_DIR

ENV \
    # App
    APP_DIR=$APP_DIR \
    SOURCE_DIR_NAME=$SOURCE_DIR_NAME \
    PORT=7860 \
    GRADIO_SERVER_NAME=0.0.0.0 \
    # uv
    UV_PROJECT_ENVIRONMENT=$UV_PROJECT_ENVIRONMENT \
    UV_CACHE_DIR=$UV_CACHE_DIR \
    # Python
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONIOENCODING=utf-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ENV STANZA_RESOURCES_DIR=$APP_DIR/.cache/stanza

EXPOSE $PORT

HEALTHCHECK --interval=15s --timeout=5s --start-period=15s --retries=5 \
    CMD python -c "import sys, http.client; c=http.client.HTTPConnection('localhost', $PORT, timeout=5); c.request('HEAD', '/'); r=c.getresponse(); sys.exit(0 if r.status==200 else 1)"

WORKDIR $APP_DIR

VOLUME $APP_DIR/.cache
VOLUME $APP_DIR/onnx

COPY --from=builder $APP_DIR/$UV_PROJECT_ENVIRONMENT $UV_PROJECT_ENVIRONMENT

COPY $SOURCE_DIR_NAME/ .

ENTRYPOINT []

CMD uv run app.py
#CMD /bin/sh
