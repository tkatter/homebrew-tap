class Sericom < Formula
  desc "CLI tool for communicating with devices over a serial connection."
  homepage "https://github.com/tkatter/sericom"
  version "0.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tkatter/sericom/releases/download/sericom/v0.5.4/sericom-aarch64-apple-darwin.tar.xz"
      sha256 "7fe8f840a968cb14fe653b98fd8413352496632dcaebe7de2a934f17cdfe13a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tkatter/sericom/releases/download/sericom/v0.5.4/sericom-x86_64-apple-darwin.tar.xz"
      sha256 "761afac5038636444261a4cb3943c498fb1b3e56326065c05e896b9ecae79d77"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tkatter/sericom/releases/download/sericom/v0.5.4/sericom-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "665eece4ba53d082f3c61ee3cd61943bfb2453ce928e21a9c025ecd0b3289e07"
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
