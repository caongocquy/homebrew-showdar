class ShowdarSkills < Formula
  desc "Software engineering lifecycle skills for coding agents"
  homepage "https://github.com/caongocquy/showdar-skills"
  version "0.12.1"
  license "MIT"

  depends_on macos: :sequoia

  on_arm do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.12.1/showdar-skills-darwin-arm64.tar.gz"
    sha256 "2fc445bed6854e196772cb4844d242efb5ea1257bdd69139a65d9d2a99d6f4ea"
  end

  on_intel do
    url "https://github.com/caongocquy/showdar-skills/releases/download/v0.12.1/showdar-skills-darwin-x64.tar.gz"
    sha256 "3474ffeffa04cd3da24e35ce4b91aa6cefd369bbddd96c66abc1f4d5efb72864"
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
