FROM python:3.11-slim

RUN groupadd -g 1000 devpi && \
    useradd -u 1000 -g 1000 -m -s /bin/bash devpi

RUN pip install --no-cache-dir devpi-server devpi-web devpi-client

VOLUME /data/devpi

EXPOSE 3141

USER devpi

ENTRYPOINT ["devpi-server", "--host", "0.0.0.0", "--port", "3141", "--serverdir", "/data/devpi"]
