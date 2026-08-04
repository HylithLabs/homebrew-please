class Please < Formula
  desc "An AI-native git CLI. You never type raw git commands."
  homepage "https://github.com/HylithLabs/please"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.1/please-aarch64-apple-darwin.tar.xz"
      sha256 "d7d7a7cede36bc7bdb242a44bc2b0c653d7f190ad545ddb39f49bbe73f860242"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.1/please-x86_64-apple-darwin.tar.xz"
      sha256 "c0e3cb938cc35e3955ba3ffb3c590faee1ef07534fc0d2535ecbaf326276d07f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.1/please-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "169996aa3d783b11457df9843f5b065e8ea11220fd8b6b64d91182933158361e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/v0.1.1/please-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "69ab4caa47358dfbc147d207fa4982572c94f7458d95501393e32ea0de48ed2b"
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
