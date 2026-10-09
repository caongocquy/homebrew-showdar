class ShowdarSkills < Formula
  desc "Software engineering lifecycle skills for coding agents"
  homepage "https://github.com/caongocquy/showdar-skills"
  version "0.17.0"
  license "MIT"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.17.0/showdar-skills-darwin-arm64.tar.gz"
    sha256 "bdb5cb2ab8349198de138a34cb7079874e3c8eb3be5b538becff98eed7135b90"
  end

  on_intel do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.17.0/showdar-skills-darwin-x64.tar.gz"
    sha256 "f2373c3a80dafa93f4698a8366e8ef4a7fb34e6f47cb0d0cd76602630bfa717f"
  end

  def install
    libexec.install Dir["*"]

    (bin/"showdar").write <<~SH
      #!/bin/sh
      exec "#{libexec}/runtime/node" "#{libexec}/node_modules/showdar-skills/bin/showdar.js" "$@"
    SH
    (bin/"showdar").chmod 0755
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/showdar --version")
  end
end
