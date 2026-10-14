class PaisansCli < Formula
  desc "Install and operate a self-hosted paisans community stack"
  homepage "https://github.com/Paisans-Software/paisans-stack"
  head "https://github.com/Paisans-Software/paisans-stack.git", branch: "develop"

  # The toolkit has not published a release yet, so there is no stable
  # version: `brew install --HEAD paisans-cli` builds from source. When a
  # release ships its binaries, add the stable block here — see README.md,
  # "When the first release ships".

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"paisans"), "./cmd/paisans"
  end

  test do
    assert_match "paisans", shell_output("#{bin}/paisans --help 2>&1")
  end
end
