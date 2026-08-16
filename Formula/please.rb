class Please < Formula
  desc "An AI-native git CLI. You never type raw git commands."
  homepage "https://github.com/HylithLabs/please"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/0.1.7/please-aarch64-apple-darwin.tar.xz"
      sha256 "e6fb80e01514c28ab217b53fa0487cbe638d6104c2679b27c3f29a59889c00c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/0.1.7/please-x86_64-apple-darwin.tar.xz"
      sha256 "6c84bbaa085f1b7c6afa256f27045ffed7aa2aa9b0a28bee31f83d8c0d654b34"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/0.1.7/please-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2ce194a6eb838d8b50346db3b4e286790ed044df65eede0fe1372d6cc0af6635"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/0.1.7/please-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c1289c0195ffadc95f1ebdeed01ffc3a3dd1f286bc2a716bbdaef88727a0ad3e"
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
