class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/37602/SimGrid-3.20.tar.gz"
  sha256 "4d4757eb45d87cf18d990d589c31d223b0ea8cf6fcd8c94fca4d38162193cef6"

  bottle do
    sha256 "75ce382a395f963425946d7f53361fa1143a2b6ca9292c63193e76139bcef91e" => :high_sierra
    sha256 "58895cb0aed9235972377d2460a18c8bc03203212ae8246450c429e837a01bcf" => :sierra
    sha256 "c0a6cf0fba37da1c281cac508bdde38aa4145fe7c50bcc9f466f5521cf95d722" => :el_capitan
    sha256 "be03b776d478cde289e3bc65f7612a4a8212165c81873ddc3361b4a91b6bdb96" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "pcre"
  depends_on "python"
  depends_on "graphviz"

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <simgrid/msg.h>

      int main(int argc, char* argv[]) {
        printf("%f", MSG_get_clock());
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-lsimgrid", "-o", "test"
    system "./test"
  end
end
