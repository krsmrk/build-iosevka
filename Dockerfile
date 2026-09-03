FROM docker.io/library/node:24-bookworm-slim

# Iosevka version to build. Override with --build-arg IOSEVKA_VERSION=vX.Y.Z
ARG IOSEVKA_VERSION=v34.8.1
# SHA-256 of https://github.com/be5invis/Iosevka/archive/refs/tags/<IOSEVKA_VERSION>.tar.gz
ARG IOSEVKA_SHA256=492d9e377c5fc508145c2194f4c0992db14885758a3eab5cf1f24913a6c8032f

RUN apt-get update && apt-get install -y --no-install-recommends \
    ttfautohint \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

RUN curl -fsSL "https://github.com/be5invis/Iosevka/archive/refs/tags/${IOSEVKA_VERSION}.tar.gz" -o /tmp/iosevka.tar.gz \
    && echo "${IOSEVKA_SHA256}  /tmp/iosevka.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/iosevka.tar.gz -C . --strip-components=1 \
    && rm /tmp/iosevka.tar.gz

RUN npm ci

COPY private-build-plans.toml .

ENTRYPOINT ["npm", "run", "build"]
CMD ["--", "contents::iosevka-skiouros"]