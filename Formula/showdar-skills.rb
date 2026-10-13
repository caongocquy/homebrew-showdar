class ShowdarSkills < Formula
  desc "Software engineering lifecycle skills for coding agents"
  homepage "https://github.com/caongocquy/showdar-skills"
  version "0.18.0"
  license "MIT"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.18.0/showdar-skills-darwin-arm64.tar.gz"
    sha256 "5b7b701113712048b4db8ed6d49b7473b1f69170f81a6369287f7a982b82f1f2"
  end

  on_intel do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.18.0/showdar-skills-darwin-x64.tar.gz"
    sha256 "31e8947503ab51448c8df6214f7e4909612be4840d5fdcedb54842dc42d36387"
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
