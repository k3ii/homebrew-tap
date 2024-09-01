class Qdir < Formula
  desc "A quick directory generator"
  homepage "https://github.com/k3ii/qdir"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k3ii/qdir/releases/download/v0.1.1/qdir-aarch64-apple-darwin.tar.xz"
      sha256 "4c9ecc7baa15225bc4d45e5d3f8459af21c776a4e3ddd24ace0cb5156b4b7f0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/qdir/releases/download/v0.1.1/qdir-x86_64-apple-darwin.tar.xz"
      sha256 "89f8a1b17ab21f819f90386eef03d6b77c8a6e38b37bc729d0003a1480f0fc1c"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/qdir/releases/download/v0.1.1/qdir-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "944aaece4acab3e907da13f9821489cef2c61b15648d87a33e8a8d3704cc8034"
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
      bin.install "qdir"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "qdir"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "qdir"
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
