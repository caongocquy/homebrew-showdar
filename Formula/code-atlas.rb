class CodeAtlas < Formula
  desc "Local-first code intelligence engine with optional AI"
  homepage "https://github.com/caongocquy/code-atlas"
  version "1.6.1"
  license "ISC"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/code-atlas/releases/download/v1.6.1/code-atlas-darwin-arm64.tar.gz"
    sha256 "6ec9cee788bdef9cf6f9933bd041645cf091cf6c1279b4354bd40a7092541dca"
  end

  on_intel do
    url "https://github.com/caongocquy/code-atlas/releases/download/v1.6.1/code-atlas-darwin-x64.tar.gz"
    sha256 "8dbcb861879dcfc327623b5136e70ca29a8c1edca968e3b04f9bfeaebfd54841"
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
