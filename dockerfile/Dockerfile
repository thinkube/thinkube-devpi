FROM python:3.9-slim

RUN pip install --no-cache-dir devpi-server==6.9.0 devpi-web==4.2.0 devpi-client==6.0.4

RUN mkdir -p /data/devpi

EXPOSE 3141

ENV DEVPISERVER_SERVERDIR=/data/devpi

RUN useradd -m -U -d /data/devpi devpi
RUN chown -R devpi:devpi /data/devpi

COPY dockerfile/scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER devpi

ENTRYPOINT ["/entrypoint.sh"]
