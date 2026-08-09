class Please < Formula
  desc "An AI-native git CLI. You never type raw git commands."
  homepage "https://github.com/HylithLabs/please"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.3/please-aarch64-apple-darwin.tar.xz"
      sha256 "4d93b15afe05db4f05e3179f1eed0dc65273733f3b1ef79bcb0667c7105da519"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.3/please-x86_64-apple-darwin.tar.xz"
      sha256 "38a9fceacca7e0992ff31a6680cb745db3764d75485767adf68489eab0b0c5d9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.3/please-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "99f44769ed5e146f7fa174f33ea3e4f112626b1bde2067597600330c96a3b639"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.3/please-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d79e13f736b165303a252a02a4f922a259a5397db8d5db25fe967703a97032a1"
    end
  end
  license "Apache-2.0"

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
    bin.install "please" if OS.mac? && Hardware::CPU.arm?
    bin.install "please" if OS.mac? && Hardware::CPU.intel?
    bin.install "please" if OS.linux? && Hardware::CPU.arm?
    bin.install "please" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
