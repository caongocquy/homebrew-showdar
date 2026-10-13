class CodeAtlas < Formula
  desc "Local-first code intelligence engine with optional AI"
  homepage "https://github.com/caongocquy/code-atlas"
  version "1.6.3"
  license "ISC"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/code-atlas/releases/download/v1.6.3/code-atlas-darwin-arm64.tar.gz"
    sha256 "ed0f7a556f79fd625e4594437234524915d94256d260c25895c30b6789b408df"
  end

  on_intel do
    url "https://github.com/caongocquy/code-atlas/releases/download/v1.6.3/code-atlas-darwin-x64.tar.gz"
    sha256 "f318b69b136870789b77881e7fc407988f2cc287b41d18a3a20c94c4e9e71b8d"
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
