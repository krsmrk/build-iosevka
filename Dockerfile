FROM node:18-bookworm-slim

RUN apt-get update && apt-get install -y \
    ttfautohint \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

RUN git clone https://github.com/be5invis/Iosevka.git
WORKDIR Iosevka

RUN npm install 

COPY private-build-plans.toml .

ENTRYPOINT ["npm", "run", "build"]
CMD ["--", "contents::iosevka-skiouros"]

