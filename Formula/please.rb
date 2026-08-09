class Please < Formula
  desc "An AI-native git CLI. You never type raw git commands."
  homepage "https://github.com/HylithLabs/please"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.5/please-aarch64-apple-darwin.tar.xz"
      sha256 "ed37137848d7810f4369329b88d74b31886e499586c68520d497c667386e2074"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.5/please-x86_64-apple-darwin.tar.xz"
      sha256 "7acc92a9ee0b21b4ed9a1b569da1584dfe3cf07baac13e8313ef774b99fa3562"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.5/please-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c5cc1f1782c80191a1b99ab3d93958f381ded428cddf0f1614cc2ea72b03636"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.5/please-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1803c4a2636df0e87f958ac99d5ad79a0c031b83721f1acb20bef0bc754fe05f"
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
