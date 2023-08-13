FROM node:18-bookworm-slim

RUN apt-get update && apt-get install -y \
    ttfautohint \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

ADD https://github.com/be5invis/Iosevka/archive/refs/tags/v26.1.0.tar.gz /tmp
RUN tar -xzf /tmp/v26.1.0.tar.gz -C . --strip-components=1

RUN npm install 

COPY private-build-plans.toml .

ENTRYPOINT ["npm", "run", "build"]
CMD ["--", "contents::iosevka-skiouros"]

