class Please < Formula
  desc "An AI-native git CLI. You never type raw git commands."
  homepage "https://github.com/HylithLabs/please"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.2/please-aarch64-apple-darwin.tar.xz"
      sha256 "59cd7befda65ad5de6c4eed9a92eeac7b7ea5ac1799ac41d4c543cbc35035fee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.2/please-x86_64-apple-darwin.tar.xz"
      sha256 "e8e5f94a2f3f3912a954c6f83254e8125b935c867a3f5e2ca0300bc112da96d2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.2/please-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "01023207d571f91f168d1e4b33c2bd655ab16ec25dfd35926618eea43ea014bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.2/please-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f6c6f0786c624fb39d8947eaa269b2a88293b140333c6e949cd0ecbb1651865b"
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
