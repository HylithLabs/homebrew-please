class Please < Formula
  desc "An AI-native git CLI. You never type raw git commands."
  homepage "https://github.com/HylithLabs/please"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/0.1.9/please-aarch64-apple-darwin.tar.xz"
      sha256 "43f40b0a233e1cf56318f0c81f2e050c51cac8233a3617c3ca9620c029772386"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/0.1.9/please-x86_64-apple-darwin.tar.xz"
      sha256 "ef1800758ec69bbb871c7228c21ad5719a50de8bc74839b9c8fdb40f6b24cee7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/0.1.9/please-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1f5deadfd61ae41ae1f00f4b74445e94d247369d2488eb20b9aa1d1d9ca2d7ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/0.1.9/please-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ce0dc9a4e4cd2f6a40995f22e6baa56ff9ab24b507e8c2f36170c1a911e6b074"
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
