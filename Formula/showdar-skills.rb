class ShowdarSkills < Formula
  desc "Software engineering lifecycle skills for coding agents"
  homepage "https://github.com/caongocquy/showdar-skills"
  version "0.15.1"
  license "MIT"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.15.1/showdar-skills-darwin-arm64.tar.gz"
    sha256 "5a9e899046d3c51127b0b237ee5dc4f251cb49811eb8b63187612f9f7fa1970f"
  end

  on_intel do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.15.1/showdar-skills-darwin-x64.tar.gz"
    sha256 "aa9e57328b8c07006313c1e7055128eff7daa2bf85e84ff0a6619460b1ab5131"
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
