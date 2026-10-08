class ShowdarSkills < Formula
  desc "Software engineering lifecycle skills for coding agents"
  homepage "https://github.com/caongocquy/showdar-skills"
  version "0.14.1"
  license "MIT"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.14.1/showdar-skills-darwin-arm64.tar.gz"
    sha256 "6f5c5503da03d22b745127745e72649e62aeb6522966d763d34e4f246b350fe5"
  end

  on_intel do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.14.1/showdar-skills-darwin-x64.tar.gz"
    sha256 "9f3e2bcad420b1bd0c2cf400b31e37defd4142b40dd581b945fcd8526c389eb5"
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
