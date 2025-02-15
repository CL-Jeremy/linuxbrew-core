class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406--6.9.10-49.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-6.9.10-49.tar.xz"
  sha256 "da1183e3047cab9cb7e2397914a831d884db71f1f441f247470506ebefd59bf0"
  head "https://github.com/imagemagick/imagemagick6.git"

  bottle do
    sha256 "6b399dc7b50bee8219e8f1e23c6ff4032b7d7b05faf59812451d3906d0d2ee3f" => :mojave
    sha256 "3d5eaf5572848fbedba8fe6a8dca40df6c63124f0551571544c72b2a18eff791" => :high_sierra
    sha256 "e5c9a7bf05357d8ac5cf497a229b3aac93ad89252bd4d2acfbd910a8bfe4a4e0" => :sierra
    sha256 "59f93dd38f90936851670e6a26145a87caa05d87751f21689ba0bb46ea238abd" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-webp=yes
      --with-openjp2
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
