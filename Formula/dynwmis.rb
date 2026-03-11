class Dynwmis < Formula
  desc "Fully dynamic solver for the Maximum (Weight) Independent Set problem"
  homepage "https://github.com/DynGraphLab/DynWMIS"
  url "https://github.com/DynGraphLab/DynWMIS/archive/refs/tags/v1.1.tar.gz"
  sha256 "a816c245c3fec50cef27da729ee951586fdf6d3754c39676447a90d79ea6a672"
  license "MIT"

  depends_on "cmake" => :build

  def install
    # Replace -march=native for portability
    inreplace "CMakeLists.txt", "-march=native", "-mtune=generic"

    # Remove unused omp.h include (OpenMP not used)
    inreplace "app/parse_parameters.h", "#include <omp.h>", "// #include <omp.h>"

    # Remove -fno-stack-limit (unsupported by clang on macOS)
    inreplace "extern/wmis/extern/KaHIP/CMakeLists.txt",
      "add_definitions(-fno-stack-limit)", "# add_definitions(-fno-stack-limit)"
    inreplace "extern/wmis/CMakeLists.txt", "-fno-stack-limit", ""

    # Remove unused MPI dependency from bundled KaHIP
    inreplace "extern/wmis/extern/KaHIP/CMakeLists.txt",
      "find_package(MPI REQUIRED)", "# find_package(MPI REQUIRED)"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
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
