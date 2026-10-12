class CodeAtlas < Formula
  desc "Local-first code intelligence engine with optional AI"
  homepage "https://github.com/caongocquy/code-atlas"
  version "1.6.2"
  license "ISC"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/code-atlas/releases/download/v1.6.2/code-atlas-darwin-arm64.tar.gz"
    sha256 "b62c7b88ee4156693147076b6013e31391f1d73ea9746be39ebb4c4f9a11446c"
  end

  on_intel do
    url "https://github.com/caongocquy/code-atlas/releases/download/v1.6.2/code-atlas-darwin-x64.tar.gz"
    sha256 "5ec6d204a58ace0c01e8db51a8aa367941bf24ff2bef8786e15504680a93c686"
  end

  def install
    libexec.install Dir["*"]

    (bin/"code-atlas").write <<~SH
      #!/bin/sh
      exec "#{libexec}/runtime/node" "#{libexec}/node_modules/@showdar2112/code-atlas/dist/cli.js" "$@"
    SH
    (bin/"code-atlas").chmod 0755
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/code-atlas --version")
  end
end
