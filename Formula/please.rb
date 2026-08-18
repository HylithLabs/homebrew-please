class Please < Formula
  desc "An AI-native git CLI. You never type raw git commands."
  homepage "https://github.com/HylithLabs/please"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/0.1.8/please-aarch64-apple-darwin.tar.xz"
      sha256 "de6057ec31357df689bc81136566f56a1879baa09219537732335f048cb517bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/0.1.8/please-x86_64-apple-darwin.tar.xz"
      sha256 "ddbe65fdc01e23ee39af947e88764bb2ca9694b9a2334dbe15f5275d373fb45e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/HylithLabs/please/releases/download/0.1.8/please-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f8dee96990bb76d5f0878b236d1e9b71da981ad9605b3cfe2d12ffe5b856dbba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/HylithLabs/please/releases/download/0.1.8/please-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "93ba7924d56596828c7b4db1bd9eefffaf6620d93a05643d1bd1d94c01198993"
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
