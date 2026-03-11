class Dynmatch < Formula
  desc "Dynamic Matching in Practice — fully dynamic maximal matching algorithms"
  homepage "https://github.com/DynGraphLab/DynMatch"
  url "https://github.com/DynGraphLab/DynMatch/archive/refs/tags/v1.0.tar.gz"
  sha256 "331d6d86bdace39616ba6cfae5b67e740a60aa0aff3b3aae7111ae3f1b099db4"
  license "MIT"

  depends_on "cmake" => :build

  def install
    # Replace -march=native for portability
    inreplace "CMakeLists.txt", "-march=native", "-mtune=generic"

    # Remove -fno-stack-limit (unsupported by clang on macOS)
    inreplace "CMakeLists.txt", "add_definitions(-fno-stack-limit)", "# add_definitions(-fno-stack-limit)"

    # Remove unused omp.h include (OpenMP not used)
    inreplace "app/parse_parameters.h", "#include <omp.h>", "// #include <omp.h>"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_BUILD_TYPE=Release"
      system "make"
    end

    bin.install "build/dynmatch"
    bin.install "build/convert_metis_seq" => "dynmatch_convert_metis_seq"
    pkgshare.install Dir["examples/*"]
  end

  test do
    assert_match "dynmatch", shell_output("#{bin}/dynmatch --help 2>&1", 1)
  end
end
