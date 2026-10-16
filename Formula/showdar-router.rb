class ShowdarRouter < Formula
  desc "Web dashboard and AI routing gateway"
  homepage "https://github.com/caongocquy/showdar-router"
  version "0.6.0"
  license "MIT"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/showdar-router/releases/download/v0.6.0/showdar-router-darwin-arm64.tar.gz"
    sha256 "dd11c319e95d3efded0437a02ceaaf8ad813ae9d4c71e0adf5328055db85bbea"
  end

  on_intel do
    url "https://github.com/caongocquy/showdar-router/releases/download/v0.6.0/showdar-router-darwin-x64.tar.gz"
    sha256 "c44590df442fa670f1c8e26a934bf071920dce5c1e76d3602ab54c4deeaa53ef"
  end

  def install
    libexec.install Dir["*"]

    (bin/"showdar-router").write <<~SH
      #!/bin/sh
      exec "#{libexec}/runtime/node" "#{libexec}/node_modules/showdar-router/cli.js" "$@"
    SH
    (bin/"showdar-router").chmod 0755
  end

  test do
    assert_path_exists libexec/"node_modules/showdar-router/cli.js"
  end
end
