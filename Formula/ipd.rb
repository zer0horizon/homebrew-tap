class Ipd < Formula
  desc "CLI tool to discover your public IP address"
  homepage "https://github.com/zer0horizon/ip-discovery"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.5.0/ipd-aarch64-apple-darwin.tar.xz"
      sha256 "8c1e98162302cbff869ce999df824947614bcac77486ab1a4bc60fbe92c997cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.5.0/ipd-x86_64-apple-darwin.tar.xz"
      sha256 "7b1cd45d399bdea86640752d130da1d8b048dd51d4b0d2ec7dd1ca2743e9cb3c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.5.0/ipd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7da81be00f631e0fb12de7dfabb0e5edd5d77055acf644cafcc61205df83e0cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.5.0/ipd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb7f41109ea6217cf3cc449c130055a7e98a2a9fdfa76bfc808f2c40ea56e5a1"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ipd"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ipd"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ipd"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ipd"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
