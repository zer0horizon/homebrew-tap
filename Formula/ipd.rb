class Ipd < Formula
  desc "CLI tool to discover your public IP address"
  homepage "https://github.com/zer0horizon/ip-discovery"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/ipd/0.1.1/ipd-aarch64-apple-darwin.tar.xz"
      sha256 "971de75d5337e8733eaadef4e3aae8cf0414be2070f748ae803117f2a1abf27c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/ipd/0.1.1/ipd-x86_64-apple-darwin.tar.xz"
      sha256 "c2d12f04e237559a1f058559bdeb4106a96c78ed20b7fd677407251dd1796fa4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/ipd/0.1.1/ipd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7895966d28938f4d672158631ecce039d2ef5f21968b79fd8f255fb166bbbc30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zer0horizon/ip-discovery/releases/download/ipd/0.1.1/ipd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac08c455f65357c2cb997a812cd2af193c4abf1c20e581c67747f438307f8d53"
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
