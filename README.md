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

## Building from source until the first release

Paisans has not published a release, so the formula has no stable
version and `brew install paisans-cli` without `--HEAD` refuses with
`No stable download is available`. `--HEAD` builds the `develop` branch with Go,
which Homebrew installs as a build dependency. `brew upgrade --fetch-HEAD
paisans-cli` rebuilds from the latest commit.

## When the first release ships

A release that attaches prebuilt binaries to its GitHub Release turns this into
an ordinary install. Add a stable block to `Formula/paisans-cli.rb`, above
`head`, with one archive per platform the release builds:

```ruby
version "0.1.0"

on_macos do
  on_arm do
    url "https://github.com/Paisans-Software/paisans-cli/releases/download/v#{version}/<asset>"
    sha256 "..."
  end
  on_intel do
    url "..."
    sha256 "..."
  end
end

on_linux do
  on_arm do
    url "..."
    sha256 "..."
  end
  on_intel do
    url "..."
    sha256 "..."
  end
end
```

Then make `install` take the prebuilt binary when there is one and build only
for `--HEAD`:

```ruby
def install
  if build.head?
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"paisans"), "./cmd/paisans"
  else
    bin.install "paisans"
  end
end
```

and make Go a build dependency of `--HEAD` alone, so a binary install does not
pull it in:

```ruby
head do
  url "https://github.com/Paisans-Software/paisans-cli.git", branch: "develop"
  depends_on "go" => :build
end
```

`<asset>` and the archive layout follow whatever the release workflow
publishes; `bin.install "paisans"` assumes the archive unpacks to a directory
holding the `paisans` binary. Each later release changes `version` and the
`sha256` lines, which `shasum -a 256` over each downloaded asset produces.

## Checking a change

```sh
brew audit --strict --tap paisans-software/paisans
brew install --HEAD paisans-cli
brew test paisans-cli
```

## License

AGPL-3.0-or-later, the same as Paisans. The full text is in `LICENSE`.
