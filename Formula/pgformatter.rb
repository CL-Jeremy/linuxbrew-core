class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v3.3.tar.gz"
  sha256 "f56ff7d7b8d59e85ac325a4b954d98b6aeae8369da74970f7948c7f4a1448ffa"

  bottle do
    cellar :any_skip_relocation
    sha256 "f93a3e3df7309520df02fb29f5ff386f52a6f081b6fec33e66d6ffa928b5e875" => :mojave
    sha256 "812ff63ece606b2edf98ae23afc75f00ea2ffd59f49eb67e6fd59d11000222ef" => :high_sierra
    sha256 "812ff63ece606b2edf98ae23afc75f00ea2ffd59f49eb67e6fd59d11000222ef" => :sierra
    sha256 "6c2749b7b847f5cf39fcf1339c8b9b3d112d3d5d891a568a1e405a8b974f6840" => :x86_64_linux
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    prefix.install (buildpath/"usr/local").children
    (libexec/"lib").install "blib/lib/pgFormatter"
    libexec.install bin/"pg_format"
    bin.install_symlink libexec/"pg_format"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
