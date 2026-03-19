class Ipd < Formula
  desc "CLI tool to discover your public IP address"
  homepage "https://github.com/zer0horizon/ip-discovery"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.2.1/ipd-aarch64-apple-darwin.tar.xz"
      sha256 "9a80ea145017a65c5fb288a7cec5d6804e5f97797196f8965a3a4eb93d059f33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.2.1/ipd-x86_64-apple-darwin.tar.xz"
      sha256 "8fee146a9863c2be321943c018d6105c7f1e956449cd2d70efe759cf2b84d065"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.2.1/ipd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d6e9318056026b62bc07735c3d54b595134be4eb1eabef9e5fabb1a80bf21778"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.2.1/ipd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "197ed34e23960d79a0657dcc4768f54008fe2a784640921ca3e8d891f2571dee"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ipd" if OS.mac? && Hardware::CPU.arm?
    bin.install "ipd" if OS.mac? && Hardware::CPU.intel?
    bin.install "ipd" if OS.linux? && Hardware::CPU.arm?
    bin.install "ipd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
