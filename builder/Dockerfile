FROM zmkfirmware/zmk-build-arm:2.5
RUN set -x \
    && apt-get update && apt-get install -y \
        jq \
    && rm -rf /var/lib/apt/lists/*
ADD entrypoint.sh /entrypoint.sh
RUN set -x \
    && chmod +x /entrypoint.sh
WORKDIR /workspace
ENTRYPOINT /entrypoint.sh
