class Kouran < Formula
  desc "View Power Outages in Mauritius"
  homepage "https://github.com/k3ii/kouran"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/k3ii/kouran/releases/download/v0.1.1/kouran-aarch64-apple-darwin.tar.xz"
      sha256 "dc5666d4ccc37a64f660705a6ad159c870227fcbcb43dbea148df2a51eb283c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/kouran/releases/download/v0.1.1/kouran-x86_64-apple-darwin.tar.xz"
      sha256 "fd283338c57eaa1d7059e9ec5c0f0e65d7eaa3ad4c72a875771f469a3f928637"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/k3ii/kouran/releases/download/v0.1.1/kouran-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f7b4316614023e61ed2705d1de26818f89760027174cef125f87a92c345ecad6"
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
      bin.install "kouran"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "kouran"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "kouran"
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
