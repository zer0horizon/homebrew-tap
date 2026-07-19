class Ipd < Formula
  desc "CLI tool to discover your public IP address"
  homepage "https://github.com/zer0horizon/ip-discovery"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.4.1/ipd-aarch64-apple-darwin.tar.xz"
      sha256 "50c88f61f34f4829d600fecfbc4680702b282c3bc30105ae6f2b74ae2175d949"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.4.1/ipd-x86_64-apple-darwin.tar.xz"
      sha256 "1df4b85a3c1802c42a167104f2b3257276292fdd2f6591276a4c8b62bf592634"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.4.1/ipd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5247d7ef09151ec4b072c4410dc62453cc5ed466304aae16b3f55b7267895d13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.4.1/ipd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23048f120d7f76b1473e964245c4046c663748fb0ba61d217a0939659ff043f0"
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
