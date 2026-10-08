class ShowdarSkills < Formula
  desc "Software engineering lifecycle skills for coding agents"
  homepage "https://github.com/caongocquy/showdar-skills"
  version "0.15.0"
  license "MIT"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.15.0/showdar-skills-darwin-arm64.tar.gz"
    sha256 "1bfaf1341631f9fb0ad0415e5301217b1cfa8619414a75c4d2331d478dd87bf9"
  end

  on_intel do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.15.0/showdar-skills-darwin-x64.tar.gz"
    sha256 "3d513c1390776c58f428af195ebba6545d7bb4b31573d1aef574bdac2084aac6"
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
