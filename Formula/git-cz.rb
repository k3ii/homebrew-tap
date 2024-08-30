class GitCz < Formula
  desc "A simple commitizen CLI tool in rust"
  homepage "https://github.com/k3ii/git-cz"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k3ii/git-cz/releases/download/0.1.0/git-commitizen-aarch64-apple-darwin.tar.xz"
      sha256 "79f092ad19b9d0fbb0bb8a63f1c5505ca8fdbee971f2991716b3fb8bc81cfa32"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/git-cz/releases/download/0.1.0/git-commitizen-x86_64-apple-darwin.tar.xz"
      sha256 "f7147c4111e27e7d6e420fc7f952060c400b11166388202ce26e9f1de340efc5"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/git-cz/releases/download/0.1.0/git-commitizen-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "64d7ac39ef1051c87a5097f6e31ea90e831c793d1236d9e6c9e0a1b073a65a71"
    end
  end

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
      bin.install "git-cz"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-cz"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-cz"
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