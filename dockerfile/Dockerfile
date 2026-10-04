# Copyright Alejandro Martínez Corriá and the Thinkube contributors
# SPDX-License-Identifier: Apache-2.0

FROM library/python:3.12-slim

RUN pip install --no-cache-dir devpi-server==6.20.1 devpi-web==5.1.0 devpi-client==7.3.0

RUN mkdir -p /data/devpi

EXPOSE 3141

ENV DEVPISERVER_SERVERDIR=/data/devpi

RUN useradd -m -U -d /data/devpi devpi
RUN chown -R devpi:devpi /data/devpi

COPY dockerfile/scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER devpi

ENTRYPOINT ["/entrypoint.sh"]
