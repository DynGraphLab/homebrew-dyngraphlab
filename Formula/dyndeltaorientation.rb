class Dyndeltaorientation < Formula
  desc "Fully dynamic exact and heuristic algorithms for edge orientation (delta-orientation)"
  homepage "https://github.com/DynGraphLab/DynDeltaOrientation"
  url "https://github.com/DynGraphLab/DynDeltaOrientation/archive/refs/tags/v2.0.tar.gz"
  sha256 "3717738a51923e5c1c6c860f73c4952bd8ca5337f70687868ec19f56a2f2b6bf"
  license "MIT"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_BUILD_TYPE=Release", "-DILP=Off"
      system "make"
    end

    bin.install "build/delta-orientations" => "dyndeltaorientation"
    bin.install "build/convert_metis_seq" => "dyndeltaorientation_convert_metis_seq"
    pkgshare.install Dir["examples/*"]
  end

  test do
    assert_match "delta-orientations", shell_output("#{bin}/dyndeltaorientation --help 2>&1", 1)
  end
end
