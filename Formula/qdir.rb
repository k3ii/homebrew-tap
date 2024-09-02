class Qdir < Formula
  desc "A quick directory generator"
  homepage "https://github.com/k3ii/qdir"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k3ii/qdir/releases/download/v0.1.2/qdir-aarch64-apple-darwin.tar.xz"
      sha256 "b341ab61276223e94cae998f2c8ebb13bbb86f6ea4be99007429317d880ab7a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/qdir/releases/download/v0.1.2/qdir-x86_64-apple-darwin.tar.xz"
      sha256 "17893d6b7cf0305b3003c54a89c95c2e459e28054a156d1c1eb4e50d6eb5c34c"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/qdir/releases/download/v0.1.2/qdir-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b5eaca1b4029b52aed53e4579941cbfd8c238e8f7cb89e9730ed29cbbc5e154"
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
