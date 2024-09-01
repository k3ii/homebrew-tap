class Qdir < Formula
  desc "A quick directory generator"
  homepage "https://github.com/k3ii/qdir"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k3ii/qdir/releases/download/v0.1.0/qdir-aarch64-apple-darwin.tar.xz"
      sha256 "45883d352812bd21070aef8051034b3577b9a396a624a5821e94294aeaa97ced"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/qdir/releases/download/v0.1.0/qdir-x86_64-apple-darwin.tar.xz"
      sha256 "85861cbb3a427eec24ecde33010114b850def395bd8a6a649692ceb246daea74"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/qdir/releases/download/v0.1.0/qdir-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f00996b25e9eca385f11bb41c584d522af4c07ca822a4d5a742bcf20daacbb68"
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
