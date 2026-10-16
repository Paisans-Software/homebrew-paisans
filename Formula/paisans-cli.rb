class PaisansCli < Formula
  desc "Install and operate a self-hosted paisans community stack"
  homepage "https://github.com/Paisans-Software/paisans-cli"
  license "AGPL-3.0-or-later"
  head "https://github.com/Paisans-Software/paisans-cli.git", branch: "develop"

  # Releases exist but carry no macOS binaries, so there is no stable block:
  # `brew install --HEAD paisans-cli` builds from source. README.md,
  # "What a stable block would install", says what one would look like.

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"paisans"), "./cmd/paisans"
  end

  test do
    assert_match "paisans", shell_output("#{bin}/paisans --help 2>&1")
  end
end
