#!/bin/bash

# Copyright Alejandro Martínez Corriá and the Thinkube contributors
# SPDX-License-Identifier: Apache-2.0

set -e

# Ensure proper permissions on the data directory
echo "Setting proper permissions on data directory..."
if [ -w "$(dirname ${DEVPISERVER_SERVERDIR})" ]; then
  chmod 700 ${DEVPISERVER_SERVERDIR}
fi

# Initialize if needed
if [ ! -f ${DEVPISERVER_SERVERDIR}/.serverversion ]; then
  echo "Initializing devpi-server..."
  devpi-init
fi

# Create a persistent secret file if it doesn't exist
SECRET_FILE="${DEVPISERVER_SERVERDIR}/secret"
if [ ! -f "$SECRET_FILE" ] || [ ! -s "$SECRET_FILE" ]; then
  echo "Generating new secret file..."
  # Generate a 64-character random string and save it to the secret file
  head -c 64 /dev/urandom | base64 | head -c 64 > "$SECRET_FILE"
  echo "Secret file created with 64 random characters"
fi

# Always ensure proper permissions on the secret file
echo "Setting proper permissions on secret file..."
if [ -f "$SECRET_FILE" ]; then
  chmod 600 "$SECRET_FILE" || echo "WARNING: Could not set permissions on secret file"
  ls -la "$SECRET_FILE"
fi

# Set additional args for proxy support
OUTSIDE_URL_ARGS=""
if [ ! -z "$DEVPI_OUTSIDE_URL" ]; then
  echo "Using outside URL: $DEVPI_OUTSIDE_URL"
  OUTSIDE_URL_ARGS="--outside-url=$DEVPI_OUTSIDE_URL"
fi

# For DevPi 6.x we need to use --trusted-proxy instead of --proxy-header
PROXY_ARGS=""
if [ ! -z "$DEVPI_TRUSTED_PROXY" ]; then
  echo "Using trusted proxy: $DEVPI_TRUSTED_PROXY"
  PROXY_ARGS="--trusted-proxy=$DEVPI_TRUSTED_PROXY"
fi

# Set Python memory control environment variables
export PYTHONUNBUFFERED=1
export PYTHONMALLOC=malloc

# For DevPi indexing, let's set a reasonable memory limit
export PYTHONASYNCIODEBUG=0

if [ ! -z "$MEMORY_LIMIT" ]; then
  echo "Memory limit specified: ${MEMORY_LIMIT}MB"
  export PYTHONGC="threshold=100,threshold1=100,threshold2=100"
  echo "Configuring DevPi for memory-constrained environment..."
fi

echo "Starting DevPi server with secret file and proxy settings"
# Further server options the deployment passes through, such as
# --request-timeout, so a setting does not need a new image.
exec devpi-server --host 0.0.0.0 --port 3141 --secretfile "$SECRET_FILE" $OUTSIDE_URL_ARGS $PROXY_ARGS $DEVPI_EXTRA_ARGS
