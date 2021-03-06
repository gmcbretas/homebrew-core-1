class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-2-4-1.tar.gz"
  version "2.4.1"
  sha256 "594c7f8a83f3502381469d643f7b185882da1dd4bc2280c16502ef980af2a776"
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    sha256 "2e830e6b8a7ae79015bb06e05b04935f6a63525cac28cca53dcb72f49334bc83" => :high_sierra
    sha256 "28bb84f75639741efbbf3a19ebffc1fc122d15fa74584440b84e265cdfd18db0" => :sierra
    sha256 "d2ca98556d58c6268b6be3f93cfc9a00a79559d081d7713ed14bc7882212b2ef" => :el_capitan
    sha256 "48724ff8b63ea446ea0f2095361ea93de0647eec2e220c8369b9910a11450213" => :yosemite
    sha256 "ac5d67aaa265fe1ab1d9c9cdfacd557e92a9cc139e6f90181515f1313d2afc50" => :x86_64_linux
  end

  option "with-cairo", "Support PNG depiction"
  option "with-java", "Compile Java language bindings"
  option "with-python@2", "Compile Python 2 language bindings"
  option "with-wxmac", "Build with GUI"

  deprecated_option "with-python" => "with-python@2"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "python@2" => :optional
  depends_on "wxmac" => :optional
  depends_on "cairo" => :optional
  depends_on "eigen"
  depends_on "swig" if build.with?("python@2") || build.with?("java")

  def install
    args = std_cmake_args
    args << "-DRUN_SWIG=ON" if build.with?("python@2") || build.with?("java")
    args << "-DJAVA_BINDINGS=ON" if build.with? "java"
    args << "-DBUILD_GUI=ON" if build.with? "wxmac"

    # Point cmake towards correct python
    if build.with? "python@2"
      ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
      pypref = `python -c 'import sys;print(sys.prefix)'`.strip
      pyinc = `python -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.strip
      args << "-DPYTHON_BINDINGS=ON"
      args << "-DPYTHON_INCLUDE_DIR='#{pyinc}'"
      args << "-DPYTHON_LIBRARY='#{pypref}/lib/libpython2.7.dylib'"
    end

    args << "-DCAIRO_LIBRARY:FILEPATH=" if build.without? "cairo"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
    (pkgshare/"java").install lib/"openbabel.jar" if build.with? "java"
  end

  def caveats
    <<~EOS
      Java libraries are installed to #{opt_pkgshare}/java so this path should
      be included in the CLASSPATH environment variable.
    EOS
  end

  test do
    system "#{bin}/obabel", "-:'C1=CC=CC=C1Br'", "-omol"
  end
end
