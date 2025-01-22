class Conze < Formula
  desc "Explore holidays"
  homepage "https://github.com/k3ii/conze"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k3ii/conze/releases/download/v0.1.2/conze-aarch64-apple-darwin.tar.xz"
      sha256 "d790f1f379c06584f662833c7dfc93f68c5c625c8ce66d1f9b451755f5301063"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/conze/releases/download/v0.1.2/conze-x86_64-apple-darwin.tar.xz"
      sha256 "5c93c77beee6c40b2ef70f931ee059630ec0038a1fac9053ff6a9cca37ce4723"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/conze/releases/download/v0.1.2/conze-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f27f39e2d9e2eb487be1353b30d0ebda5fd1fa46eed3c7e3fd2b13ae90c2fc8a"
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
