class Kouran < Formula
  desc "View Power Outages in Mauritius"
  homepage "https://github.com/k3ii/kouran"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k3ii/kouran/releases/download/v0.1.3/kouran-aarch64-apple-darwin.tar.xz"
      sha256 "ef047174faa06004b2b5986d37f96158e7708b6617a51f2ca59731514aaa6e2a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/kouran/releases/download/v0.1.3/kouran-x86_64-apple-darwin.tar.xz"
      sha256 "3fe390c122c3571991b8111fe1140d5e620d7fa00bd47778b677427a72e0e322"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/k3ii/kouran/releases/download/v0.1.3/kouran-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fe55c4314bb86a25c76e019a183f022d357e661a1d04055a0efb743a84965c65"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "kouran" if OS.mac? && Hardware::CPU.arm?
    bin.install "kouran" if OS.mac? && Hardware::CPU.intel?
    bin.install "kouran" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
