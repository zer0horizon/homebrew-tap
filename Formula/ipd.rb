class Ipd < Formula
  desc "CLI tool to discover your public IP address"
  homepage "https://github.com/zer0horizon/ip-discovery"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.2.1/ipd-aarch64-apple-darwin.tar.xz"
      sha256 "2f00dea4026e9e121adf871b7707699897a86d458b05f2ae7121a4fa93b1016b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.2.1/ipd-x86_64-apple-darwin.tar.xz"
      sha256 "d7530b29efdb472b03af12b6a3a17ead4fb375cc8bd8475dc33b1ba9c902d3f0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.2.1/ipd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "643b4d5d708a26082cf98d0337eaba95c16d5a0c8126ca41d3fed51b6c4dfa2e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/v0.2.1/ipd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0d91b6b7716ed789d7fdd64f0398ce87b4f9712d846956dabd38645070baa218"
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
