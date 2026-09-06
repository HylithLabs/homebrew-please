class Please < Formula
  desc "An AI-native git CLI. You never type raw git commands."
  homepage "https://github.com/HylithLabs/please"
  version "2.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/2.1.0/please-aarch64-apple-darwin.tar.xz"
      sha256 "c8116fe024c3e5c40ccdf12f6a17a8ae35632956012bff2cc762b58c8eb48801"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/2.1.0/please-x86_64-apple-darwin.tar.xz"
      sha256 "240d0f2a294285dbfbed32b0c51bdc2a367de715e99cff97ae0adb7eb32abc44"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/2.1.0/please-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae8b541f3313302d815953ffba047948afb60c350518993358cb5ec80df7c7d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/2.1.0/please-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "47ae136ced4a043e755adbd54731c4eddaa32fd8eaeecd44d0a44ca36340df86"
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
