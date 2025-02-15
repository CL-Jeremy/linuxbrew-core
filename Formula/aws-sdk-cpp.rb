class CIRequirement < Requirement
  fatal true
  satisfy { ENV["CIRCLECI"].nil? && ENV["TRAVIS"].nil? }
end

class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.120.tar.gz"
  sha256 "15588d63bd1946aa08882ad071251b0242be87a3490d027d8c7bef0f20c9cab0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "3f53cfebf69ba86638b5ec34edbc996e30fb8a4bb2dcd9427d2710fdc78625bb" => :mojave
    sha256 "c5a1b3e28a9c10d5a1fb0ef3c895730e957b78302069c62125a1bf6b00d441db" => :high_sierra
    sha256 "e0a96cdff8931458f6e90dc04c9b0a7ab4eaab9914f55a8a8b43fc3afb1c9c62" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "curl" unless OS.mac?
  depends_on CIRequirement

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
