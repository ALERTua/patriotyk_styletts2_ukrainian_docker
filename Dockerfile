# torch==2.2.0 requires 3.12
ARG PYTHON_VERSION=3.12
ARG APP_DIR=/usr/src/app
ARG SOURCE_DIR_NAME=styletts2-ukrainian
ARG GRADIO_SERVER_PORT=7860
ARG GRADIO_SERVER_NAME=0.0.0.0
ARG DATA_DIR=/data

# -----------------------------------------------------------------
FROM ghcr.io/astral-sh/uv:python${PYTHON_VERSION}-trixie-slim AS builder

ARG APP_DIR
ARG SOURCE_DIR_NAME
ARG DATA_DIR

ENV \
    # uv
    UV_PYTHON_DOWNLOADS=0 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_FROZEN=1 \
    UV_NO_PROGRESS=true \
    # pip
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    # Python
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONIOENCODING=utf-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    # ARG
    APP_DIR=$APP_DIR \
    SOURCE_DIR_NAME=$SOURCE_DIR_NAME \
    DATA_DIR=$DATA_DIR

ENV \
    # ARG-based ENV Vars
    XDG_CACHE_HOME=$DATA_DIR/.cache \
    STANZA_RESOURCES_DIR=$DATA_DIR/stanza \
    UV_PROJECT_ENVIRONMENT=$DATA_DIR/venv \
    UV_CACHE_DIR=$DATA_DIR/uv_cache

WORKDIR $APP_DIR


# -----------------------------------------------------------------
FROM builder AS staging

ARG GRADIO_SERVER_PORT
ARG GRADIO_SERVER_NAME

ENV \
    GRADIO_SERVER_PORT=$GRADIO_SERVER_PORT \
    GRADIO_SERVER_NAME=$GRADIO_SERVER_NAME \
    GRADIO_ANALYTICS_ENABLED=False

RUN apt-get update \
    && apt-get install --no-install-recommends -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY $SOURCE_DIR_NAME/ .
COPY --chmod=+x entrypoint.sh .
COPY entrypoint.py .

EXPOSE $GRADIO_SERVER_PORT

VOLUME $DATA_DIR

ENTRYPOINT []
CMD /bin/bash


# -----------------------------------------------------------------
FROM staging AS dev

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl htop \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT []
CMD /bin/bash


# -----------------------------------------------------------------
FROM staging AS production

LABEL maintainer="ALERT <alexey.rubasheff@gmail.com>"

HEALTHCHECK --interval=15s --timeout=5s --start-period=3s --retries=10 \
    CMD python -c "import sys, http.client; c=http.client.HTTPConnection('localhost', $GRADIO_SERVER_PORT, timeout=5); c.request('HEAD', '/'); r=c.getresponse(); sys.exit(0 if r.status==200 else 1)"

ENTRYPOINT []
# CMD ["sleep", "infinity"]
CMD ./entrypoint.sh
