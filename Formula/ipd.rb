class Ipd < Formula
  desc "CLI tool to discover your public IP address"
  homepage "https://github.com/zer0horizon/ip-discovery"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.3.0/ipd-aarch64-apple-darwin.tar.xz"
      sha256 "a3251d108ddc05dffe72a15908681ee61d620c61da17efcbbd5ba8fd41b17846"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.3.0/ipd-x86_64-apple-darwin.tar.xz"
      sha256 "9f5bce2ccac8a55e73b10981b51bbcce0f240cc62db09d727a5cf5bdb2951b51"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.3.0/ipd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8d9cc4d2ead8338eff153bfd195b51eb9d8eafe1abb528b87b5451f32ede67e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.3.0/ipd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b3288ba35128b037cb4888eecb469349fcce7dabee99dc752416fb1de817d11"
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
