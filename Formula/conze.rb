class Conze < Formula
  desc "Explore holidays"
  homepage "https://github.com/k3ii/conze"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k3ii/conze/releases/download/v0.1.1/conze-aarch64-apple-darwin.tar.xz"
      sha256 "456d43f859c5d06409dcf12ee59a592d5cb3b301d1e07da65570f1133f38efab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/conze/releases/download/v0.1.1/conze-x86_64-apple-darwin.tar.xz"
      sha256 "a1997d9f3bead98355692e31cc0a4ee26b741c802a927623a4c7946c68ee5255"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/conze/releases/download/v0.1.1/conze-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dacde72eacea0c04fe0273b17b6e930f942450fabc5e9db7c47474cca396dcf3"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "conze"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "conze"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "conze"
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
