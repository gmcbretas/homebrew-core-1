class KyotoTycoon < Formula
  desc "Database server with interface to Kyoto Cabinet"
  homepage "http://fallabs.com/kyototycoon/"
  url "http://fallabs.com/kyototycoon/pkg/kyototycoon-0.9.56.tar.gz"
  sha256 "553e4ea83237d9153cc5e17881092cefe0b224687f7ebcc406b061b2f31c75c6"
  revision 2

  bottle do
    sha256 "7be4c6e507a1d8a1d526c82c11dd41b150806211c48388ab9a0dd790875fff79" => :high_sierra
    sha256 "55a2e33c172afca9880553097beef413abce0c2f913c0ca1aa20ff5873732d14" => :sierra
    sha256 "33d857c99b29a62a42965ebd5639990cdbfeb3584adee249caff81ab0cdf4328" => :el_capitan
    sha256 "719e0bf6552fb1b9a5cdaf60a99e4fc020e5d621f5ab77baa1e32aaacf4e9dbf" => :x86_64_linux
  end

  depends_on "lua" => :recommended
  depends_on "kyoto-cabinet"

  patch :DATA if MacOS.version >= :mavericks || !OS.mac?

  def install
    # Locate kyoto-cabinet for non-/usr/local builds
    cabinet = Formula["kyoto-cabinet"].opt_prefix
    args = ["--prefix=#{prefix}", "--with-kc=#{cabinet}"]

    if build.with? "lua"
      lua = Formula["lua"].opt_prefix
      args << "--with-lua=#{lua}"
    else
      args << "--enable-lua"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end


__END__
--- a/ktdbext.h  2013-11-08 09:34:53.000000000 -0500
+++ b/ktdbext.h  2013-11-08 09:35:00.000000000 -0500
@@ -271,7 +271,7 @@
       if (!logf("prepare", "started to open temporary databases under %s", tmppath.c_str()))
         err = true;
       stime = kc::time();
-      uint32_t pid = getpid() & kc::UINT16MAX;
+      uint32_t pid = kc::getpid() & kc::UINT16MAX;
       uint32_t tid = kc::Thread::hash() & kc::UINT16MAX;
       uint32_t ts = kc::time() * 1000;
       for (size_t i = 0; i < dbnum_; i++) {
