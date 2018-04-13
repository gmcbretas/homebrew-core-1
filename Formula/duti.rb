class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.4.tar.gz"
  sha256 "3f8f599899a0c3b85549190417e4433502f97e332ce96cd8fa95c0a9adbe56de"
  head "https://github.com/moretension/duti.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "7d2f8e2a40a50e580c10af176ce1f3aacab03059e671705d02309ac46382b993" => :high_sierra
    sha256 "8f34c5664b0a9c05274fd67102fca6c969f7dc966279b2ca0f11906df3d2d03a" => :sierra
    sha256 "53748f3ad97a48b468326e66d869e20c05fc1f67219ac3ea8a147b558717ee45" => :el_capitan
    sha256 "c2661fc4e59d5cc941a416bf7abad035af3d15f75e7bca73d2bc29706d89f560" => :yosemite
    sha256 "e301c36a6809acc2a0dd62fba59eac4820b90cf2cf9df30f46480f7ce736dad3" => :mavericks
  end

  depends_on "autoconf" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "com.apple.TextEdit", shell_output("#{bin}/duti -l public.text"),
                 "TextEdit not found among the handlers for public.text"
  end
end
