# build-iosevka

Builds a custom [Iosevka](https://github.com/be5invis/Iosevka) variant
(**Iosevka Skiouros**, defined in [`private-build-plans.toml`](private-build-plans.toml))
inside Docker, on top of a pinned upstream release.

## How it works

- The `Dockerfile` downloads the pinned Iosevka source tarball, verifies its
  SHA-256, installs npm dependencies (`npm ci`), and builds the font via
  `npm run build -- contents::iosevka-skiouros`.
- `.github/workflows/build-font-action.yml` runs this on every push to `main`
  (and on demand via *Run workflow*) and uploads everything from `dist/` as an
  artifact named `iosevka-<version>`.

## Updating the Iosevka version

1. Pick the new version from https://github.com/be5invis/Iosevka/releases.
2. Compute the new source tarball hash:
   ```sh
   curl -sL "https://github.com/be5invis/Iosevka/archive/refs/tags/vX.Y.Z.tar.gz" | sha256sum
   ```
3. Update the version + hash in **both** places:
   - `Dockerfile`: `IOSEVKA_VERSION` and `IOSEVKA_SHA256` args
   - `.github/workflows/build-font-action.yml`: `env.IOSEVKA_VERSION`
4. Check [`doc/custom-build.md`](https://github.com/be5invis/Iosevka/blob/master/doc/custom-build.md)
   for renamed options or variants and adjust `private-build-plans.toml` if needed.

## Building locally

```sh
docker build -t iosevka-custom .
docker run --rm -v "$PWD/dist:/usr/src/app/dist" iosevka-custom
```

Results land in `./dist/` (all styles + webfonts). Building takes a while
(~40–90 min) and peaks at >1 GB RAM per parallel job; constrain with
`npm run build -- contents::iosevka-skiouros --jCmd=2` if needed (edit the
`CMD` in the Dockerfile or override the container command).