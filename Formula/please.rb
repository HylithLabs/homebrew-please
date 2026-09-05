class Please < Formula
  desc "An AI-native git CLI. You never type raw git commands."
  homepage "https://github.com/HylithLabs/please"
  version "2.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/2.0.0/please-aarch64-apple-darwin.tar.xz"
      sha256 "77e3196e5cce4b2ab7bc3055100af1fd8583cd85db629927af625b661d2738f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/2.0.0/please-x86_64-apple-darwin.tar.xz"
      sha256 "f611948e1e9c3b1b91023b244e47dc129c41d12695b873d64442d66b71844de3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/2.0.0/please-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa90528f62d7ff215816259a28472aff9dd1ce6c1df7531d4e1a7d797949656b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/2.0.0/please-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ac126b54916230955cf491ef7bedfdcd04e371eee9aa9e44984ef99b7266e08"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "please"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "please"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "please"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "please"
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
