# homebrew-paisans

The Homebrew tap for [Paisans](https://github.com/Paisans-Software/paisans-cli),
the toolkit for installing and operating a self-hosted paisans community stack.

```sh
brew tap paisans-software/paisans
brew trust paisans-software/paisans
brew install paisans-cli
```

Homebrew refuses to load a formula from a third-party tap until the tap is
trusted, which is what `brew trust` does. `brew trust --formula
paisans-software/paisans/paisans-cli` trusts this one formula instead of the
whole tap.

The formula is `paisans-cli`; the command it installs is `paisans`.

## Installing

`brew install paisans-cli` builds the newest Paisans release from its source
tarball, pre-releases included: today `v0.3.0-rc.15`. Go is a build dependency,
which Homebrew installs. A tarball carries no git metadata, so the formula
passes the release tag as the build's commit
(`-X github.com/paisans-software/paisans-cli/internal/version.buildCommit=v<version>`),
and every record Paisans writes names the release that wrote it. `paisans
version` prints `paisans <version>`.

`brew install --HEAD paisans-cli` builds the `develop` branch instead, which
names its commit from git. `brew upgrade --fetch-HEAD paisans-cli` rebuilds it
from the latest commit.

## Releasing a new version here

Each Paisans release, pre-releases included, changes three lines of the
formula: the tag in `url`, `version`, and `sha256`, the checksum of the source
tarball:

```sh
curl -sL https://github.com/Paisans-Software/paisans-cli/archive/refs/tags/v<version>.tar.gz | shasum -a 256
```

Releases also attach static Linux binaries (`paisans-linux-amd64`,
`paisans-linux-arm64` and `SHA256SUMS`), for a host owner who runs
`sudo paisans site admit --request` on the host itself. The formula builds
from source on every platform and does not use them.

## Checking a change

```sh
brew audit --strict --tap paisans-software/paisans
brew install --build-from-source paisans-cli
brew test paisans-cli
```

## License

AGPL-3.0-or-later, the same as Paisans. The full text is in `LICENSE`.
