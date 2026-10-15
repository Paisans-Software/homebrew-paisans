# homebrew-paisans

The Homebrew tap for [Paisans](https://github.com/Paisans-Software/paisans-cli),
the toolkit for installing and operating a self-hosted paisans community stack.

```sh
brew tap paisans-software/paisans
brew trust paisans-software/paisans
brew install --HEAD paisans-cli
```

Homebrew refuses to load a formula from a third-party tap until the tap is
trusted, which is what `brew trust` does. `brew trust --formula
paisans-software/paisans/paisans-cli` trusts this one formula instead of the
whole tap.

The formula is `paisans-cli`; the command it installs is `paisans`.

## Installing

The formula installs from source only. It has no stable block, so `brew install
paisans-cli` without `--HEAD` refuses with `No stable download is available`.
`--HEAD` builds the `develop` branch with Go, which Homebrew installs as a
build dependency. `brew upgrade --fetch-HEAD paisans-cli` rebuilds from the
latest commit.

## What releases carry

Paisans has published releases (v0.1.0 and v0.2.0), tagged from `main`. Releases
carry no prebuilt macOS binaries. The release workflow attaches static Linux
binaries, bare executables rather than archives, plus a `SHA256SUMS` file:

* `paisans-linux-amd64`
* `paisans-linux-arm64`
* `SHA256SUMS`

They exist for a host owner to run `paisans host admit` on the host itself, and
they are attached by the workflow from the release after v0.2.0; v0.1.0 and
v0.2.0 have no assets. Homebrew on Linux could install them, but a stable
formula for macOS would need macOS binaries first, so the tap stays HEAD-only.

## What a stable block would install

If the formula gains a stable block, it would cover Linux only, one bare binary
per architecture, and `install` would rename the download:

```ruby
version "X.Y.Z"

on_linux do
  on_arm do
    url "https://github.com/Paisans-Software/paisans-cli/releases/download/v#{version}/paisans-linux-arm64"
    sha256 "..."
  end
  on_intel do
    url "https://github.com/Paisans-Software/paisans-cli/releases/download/v#{version}/paisans-linux-amd64"
    sha256 "..."
  end
end
```

```ruby
def install
  if build.head?
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"paisans"), "./cmd/paisans"
  else
    bin.install Dir["paisans-linux-*"].first => "paisans"
  end
end
```

Go would be a build dependency of `--HEAD` alone, so a binary install does not
pull it in:

```ruby
head do
  url "https://github.com/Paisans-Software/paisans-cli.git", branch: "develop"
  depends_on "go" => :build
end
```

Each release changes `version` and the `sha256` lines, which the release's
`SHA256SUMS` provides.

## Checking a change

```sh
brew audit --strict --tap paisans-software/paisans
brew install --HEAD paisans-cli
brew test paisans-cli
```

## License

AGPL-3.0-or-later, the same as Paisans. The full text is in `LICENSE`.
