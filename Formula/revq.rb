class Revq < Formula
  desc "Review and query your pull requests"
  homepage "https://github.com/k3ii/revq"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k3ii/revq/releases/download/v0.1.0/revq-aarch64-apple-darwin.tar.xz"
      sha256 "c11ecc8446b875db90e92f7a762ee0c82a5c654098ea88c30424d248844d60ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/revq/releases/download/v0.1.0/revq-x86_64-apple-darwin.tar.xz"
      sha256 "fc9ed068c16dbfa2222a61585d61a20d98f1c0f958f18c8f5ca2d10ed1a60d95"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/revq/releases/download/v0.1.0/revq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "44d5dcdd4069e612bd77df34ac4f95c3578438b7efd60b08dde6e01a88b53018"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "revq"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "revq"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "revq"
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
