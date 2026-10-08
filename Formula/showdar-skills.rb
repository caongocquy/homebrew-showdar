class ShowdarSkills < Formula
  desc "Software engineering lifecycle skills for coding agents"
  homepage "https://github.com/caongocquy/showdar-skills"
  version "0.14.2"
  license "MIT"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.14.2/showdar-skills-darwin-arm64.tar.gz"
    sha256 "754886de331fe0c5d0296aafce8d450e5a2d3bbd0416d44c934c555f651f2c4a"
  end

  on_intel do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.14.2/showdar-skills-darwin-x64.tar.gz"
    sha256 "90e957e47e9259dc919d05b8c7daec4b40318426a78ad43a1fce7984d1aa8454"
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
