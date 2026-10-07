#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";

const packages = [
  {
    repo: "caongocquy/code-atlas",
    formula: "code-atlas.rb",
    className: "CodeAtlas",
    desc: "Local-first code intelligence engine with optional AI",
    homepage: "https://github.com/caongocquy/code-atlas",
    license: "ISC",
    assetPrefix: "code-atlas",
    binName: "code-atlas",
    entry: "node_modules/@showdar2112/code-atlas/dist/cli.js",
    functionalTest: true,
  },
  {
    repo: "caongocquy/showdar-skills",
    formula: "showdar-skills.rb",
    className: "ShowdarSkills",
    desc: "Software engineering lifecycle skills for coding agents",
    homepage: "https://github.com/caongocquy/showdar-skills",
    license: "MIT",
    assetPrefix: "showdar-skills",
    binName: "showdar",
    entry: "node_modules/showdar-skills/bin/showdar.js",
    functionalTest: true,
  },
  {
    repo: "caongocquy/showdar-router",
    formula: "showdar-router.rb",
    className: "ShowdarRouter",
    desc: "Web dashboard and AI routing gateway",
    homepage: "https://github.com/caongocquy/showdar-router",
    license: "MIT",
    assetPrefix: "showdar-router",
    binName: "showdar-router",
    entry: "node_modules/showdar-router/cli.js",
    functionalTest: false,
  },
];

const token = process.env.GITHUB_TOKEN;
const headers = {
  Accept: "application/vnd.github+json",
  "User-Agent": "homebrew-showdar-sync",
  ...(token ? { Authorization: `Bearer ${token}` } : {}),
};

async function getJson(url) {
  const response = await fetch(url, { headers });
  if (!response.ok) throw new Error(`${response.status} ${response.statusText}: ${url}`);
  return response.json();
}

async function getText(url) {
  const response = await fetch(url, { headers });
  if (!response.ok) throw new Error(`${response.status} ${response.statusText}: ${url}`);
  return response.text();
}

function assetByName(release, name) {
  return release.assets.find((asset) => asset.name === name);
}

async function checksumFor(release, assetName) {
  const checksumAsset = assetByName(release, `${assetName}.sha256`);
  if (!checksumAsset) return null;
  const body = await getText(checksumAsset.browser_download_url);
  const match = body.trim().match(/^([a-f0-9]{64})\s+/i);
  if (!match) throw new Error(`Invalid checksum file for ${release.tag_name}/${assetName}`);
  return match[1].toLowerCase();
}

function formulaSource(config, release, assets) {
  const version = release.tag_name.replace(/^v/, "");
  const testBlock = config.functionalTest
    ? `  test do
    assert_match version.to_s, shell_output("#{bin}/${config.binName} --version")
  end
`
    : `  test do
    assert_path_exists libexec/"${config.entry}"
  end
`;

  return `class ${config.className} < Formula
  desc "${config.desc}"
  homepage "${config.homepage}"
  version "${version}"
  license "${config.license}"

  depends_on macos: :sequoia
  depends_on "node@24"

  on_arm do
    url "${assets.arm.url}"
    sha256 "${assets.arm.sha256}"
  end

  on_intel do
    url "${assets.intel.url}"
    sha256 "${assets.intel.sha256}"
  end

  def install
    libexec.install Dir["*"]

    (bin/"${config.binName}").write <<~SH
      #!/bin/sh
      exec "#{Formula["node@24"].opt_bin}/node" "#{libexec}/${config.entry}" "$@"
    SH
    (bin/"${config.binName}").chmod 0755
  end

${testBlock}end
`;
}

fs.mkdirSync("Formula", { recursive: true });

let updated = 0;
for (const config of packages) {
  const release = await getJson(`https://api.github.com/repos/${config.repo}/releases/latest`);
  if (release.draft || release.prerelease || !/^v\d+\.\d+\.\d+$/.test(release.tag_name)) {
    console.log(`skip ${config.repo}: latest release is not a stable semver tag`);
    continue;
  }

  const armName = `${config.assetPrefix}-darwin-arm64.tar.gz`;
  const intelName = `${config.assetPrefix}-darwin-x64.tar.gz`;
  const armAsset = assetByName(release, armName);
  const intelAsset = assetByName(release, intelName);

  if (!armAsset || !intelAsset) {
    console.log(`skip ${config.repo}@${release.tag_name}: macOS release assets are not published yet`);
    continue;
  }

  const [armSha, intelSha] = await Promise.all([
    checksumFor(release, armName),
    checksumFor(release, intelName),
  ]);
  if (!armSha || !intelSha) {
    console.log(`skip ${config.repo}@${release.tag_name}: SHA-256 assets are not published yet`);
    continue;
  }

  const source = formulaSource(config, release, {
    arm: { url: armAsset.browser_download_url, sha256: armSha },
    intel: { url: intelAsset.browser_download_url, sha256: intelSha },
  });
  const target = path.join("Formula", config.formula);
  const previous = fs.existsSync(target) ? fs.readFileSync(target, "utf8") : null;
  if (previous === source) {
    console.log(`unchanged ${target} (${release.tag_name})`);
    continue;
  }

  fs.writeFileSync(target, source);
  console.log(`updated ${target} -> ${release.tag_name}`);
  updated++;
}

console.log(`formula sync complete: ${updated} updated`);
