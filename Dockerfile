FROM python:3.12-slim AS production

ENV GRADIO_SERVER_NAME="0.0.0.0"

ENV PORT=7860
EXPOSE $PORT

VOLUME /usr/src/app/.cache
VOLUME /usr/src/app/onnx
WORKDIR /usr/src/app

RUN apt-get update \
    && apt-get install --no-install-recommends -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY styletts2-ukrainian/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy the contents of styletts2-ukrainian to the WORKDIR
COPY styletts2-ukrainian/ .

CMD ["python", "app.py"]
