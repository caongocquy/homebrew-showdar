class CodeAtlas < Formula
  desc "Local-first code intelligence engine with optional AI"
  homepage "https://github.com/caongocquy/code-atlas"
  version "1.6.0"
  license "ISC"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/code-atlas/releases/download/v1.6.0/code-atlas-darwin-arm64.tar.gz"
    sha256 "a3137fec9a468c3fbe5e732deedfc2ea1c52faec5bc7afcea0757f24272a1e24"
  end

  on_intel do
    url "https://github.com/caongocquy/code-atlas/releases/download/v1.6.0/code-atlas-darwin-x64.tar.gz"
    sha256 "ffebdd8e0dc55bac29541a888902d869f6fb45dcfc595c69bd91ba2d738a60f7"
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
