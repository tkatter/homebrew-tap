class Sericom < Formula
  desc "CLI tool for communicating with devices over a serial connection."
  homepage "https://github.com/tkatter/sericom"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tkatter/sericom/releases/download/sericom/v0.5.2/sericom-aarch64-apple-darwin.tar.xz"
      sha256 "f0c8994d8c3a1b636a01cbf88a9c86ab1f3def5ec7511cabe01f0c6c89822e9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tkatter/sericom/releases/download/sericom/v0.5.2/sericom-x86_64-apple-darwin.tar.xz"
      sha256 "c46f082e570ed71cb45ea169bb999d43304d6b565b443a5eb00267aa467058c0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tkatter/sericom/releases/download/sericom/v0.5.2/sericom-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d6794112ca8c1cd4a4636027c3b42d44748b4f7099744802650e7d6d9edba83e"
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "sericom" if OS.mac? && Hardware::CPU.arm?
    bin.install "sericom" if OS.mac? && Hardware::CPU.intel?
    bin.install "sericom" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
