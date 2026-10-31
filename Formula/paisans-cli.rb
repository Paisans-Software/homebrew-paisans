class PaisansCli < Formula
  desc "Install and operate a self-hosted paisans community stack"
  homepage "https://github.com/Paisans-Software/paisans-cli"
  url "https://github.com/Paisans-Software/paisans-cli/archive/refs/tags/v0.3.0-rc.22.tar.gz"
  version "0.3.0-rc.22"
  sha256 "1ff8b358a098e9e7feed1d8deda46f11ac216b7a49ed7ee3632c3d6efac15e53"
  license "AGPL-3.0-or-later"
  head "https://github.com/Paisans-Software/paisans-cli.git", branch: "develop"

  # The stable build is the newest release, pre-releases included, built from
  # its source tarball. A tarball carries no git metadata, so the build names
  # its release tag as its commit; paisans refuses a tag that is not its own
  # version. `brew install --HEAD paisans-cli` builds develop, which names its
  # commit from git.

  depends_on "go" => :build

  def install
    ldflags = %w[-s -w]
    ldflags << "-X github.com/paisans-software/paisans-cli/internal/version.buildCommit=v#{version}" if build.stable?
    system "go", "build", *std_go_args(ldflags:, output: bin/"paisans"), "./cmd/paisans"
  end

  test do
    assert_match "paisans", shell_output("#{bin}/paisans --help 2>&1")
  end
end
