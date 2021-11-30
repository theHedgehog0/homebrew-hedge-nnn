

class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.4.tar.gz"
  sha256 "e04a3f0f0c2af1e18cb6f005d18267c7703644274d21bb93f03b30e4fd3d1653"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  depends_on "gnu-sed"
  depends_on "readline"
  depends_on "upx" => :build

  uses_from_macos "ncurses"
  
  conflicts_with: "nnn", because: "This also creates an nnn binary."

  def install
    system "make", "install", "PREFIX=#{prefix}", "O_GITSTATUS=1", "O_NOX11=1", "O_NOMOUSE=1", "O_NERD=1"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"
  end

  test do

    # Testing this curses app requires a pty
    require "pty"

    (testpath/"testdir").mkdir
    PTY.spawn(bin/"nnn", testpath/"testdir") do |r, w, _pid|
      w.write "q"
      assert_match "~/testdir", r.read
    end
  end
end
