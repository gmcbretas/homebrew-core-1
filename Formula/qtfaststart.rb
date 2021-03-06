class Qtfaststart < Formula
  desc "Utility for Quicktime files"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-12.3.tar.gz"
  sha256 "115b659022dd387f662e26fbc5bc0cc14ec18daa100003ffd34f4da0479b272e"

  bottle do
    cellar :any_skip_relocation
    sha256 "4534f204dcc950ad18c3a141119fcd8d9a9623645092ae3f003b08dd94851dcf" => :high_sierra
    sha256 "a11b3b623a2682567830cb05810ed4445037f5b43a52f2378a10291aad70a2c6" => :sierra
    sha256 "00ed1702b08f3fe7d0660aab963f15baab6a5bac8db02048fe5d0b4d80b4abe0" => :el_capitan
    sha256 "d688747087c789bd6d868809fbf9232ab44eb1a491e340e5b2939f0f3f91f424" => :x86_64_linux
  end

  resource "mov" do
    url "https://github.com/van7hu/fanca/raw/master/examples/kmplayer/samples/H264_test4_Talkingheadclipped_mov_480x320.mov"
    sha256 "5af004e182ac7214dadf34816086d0a25c7a6cac568ae3741fca527cbbd242fc"
  end

  def install
    system ENV.cc, "-o", "tools/qt-faststart", "tools/qt-faststart.c"
    bin.install "tools/qt-faststart"
  end

  test do
    input = "H264_test4_Talkingheadclipped_mov_480x320.mov"
    output = "out.mov"
    resource("mov").stage testpath
    system "#{bin}/qt-faststart", input, output

    assert_predicate testpath/output, :exist?
  end
end
