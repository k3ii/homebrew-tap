class Conze < Formula
  desc "Explore holidays"
  homepage "https://github.com/k3ii/conze"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k3ii/conze/releases/download/v0.1.0/conze-aarch64-apple-darwin.tar.xz"
      sha256 "5e016c78c6b19775e3bac8b18c5945d4c3352ec14809b9116493d519e49e0ef5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/conze/releases/download/v0.1.0/conze-x86_64-apple-darwin.tar.xz"
      sha256 "665802fe77366149eb3afc1984efca0e6d94b3b95e3aa65f25d5e02c81c0401a"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/conze/releases/download/v0.1.0/conze-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "391280c6e82fb6e9d2e3600d1431d4be9e9f217a188e2c57df15eaac00b95ff1"
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
