class Dynwmis < Formula
  desc "Fully dynamic solver for the Maximum (Weight) Independent Set problem"
  homepage "https://github.com/DynGraphLab/DynWMIS"
  url "https://github.com/DynGraphLab/DynWMIS/archive/refs/tags/v1.0.tar.gz"
  sha256 "2fb0fb80100034be555e2e6261e58ef4a8702eb19afa114c50e33013dd32dd65"
  license "MIT"

  depends_on "cmake" => :build

  fails_with :clang do
    cause "Requires OpenMP support"
  end

  def install
    # Replace -march=native for portability
    inreplace "CMakeLists.txt", "-march=native", "-mtune=generic"

    # Remove stale CMakeCache from release tarball
    rm_rf "build"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_BUILD_TYPE=Release"
      system "make"
    end

    bin.install "build/dynwmis"
    bin.install "build/convert_metis_seq" => "dynwmis_convert_metis_seq"
    pkgshare.install Dir["examples/*"]
  end

  test do
    assert_match "dynwmis", shell_output("#{bin}/dynwmis --help 2>&1", 1)
  end
end
