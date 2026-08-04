class Please < Formula
  desc "An AI-native git CLI. You never type raw git commands."
  homepage "https://github.com/HylithLabs/please"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.0/please-aarch64-apple-darwin.tar.xz"
      sha256 "7a3a4b9a412d36f7da7658def19b50a6b32db6f1221d6d49cd243a68399b8308"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.0/please-x86_64-apple-darwin.tar.xz"
      sha256 "3cc28bd01e031e7b14848a4d8f82683870410938c2769c9eefcb28276066bec8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.0/please-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d30900d738eb0ab7e7a68758263472cc52e5772bc1358b2676b6f51f398b47b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.0/please-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "07c3193b05ccefcaa642eabf728c35d2187467f060f7d51d73593615d190a18d"
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
