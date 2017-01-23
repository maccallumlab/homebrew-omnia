class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "https://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.12.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.12/doxygen-1.8.12.src.tar.gz"
  sha256 "792d4091cbdf228549ff2033dd71ff7ea5029c6b436317cc5ec866e71302df6c"
  head "https://github.com/doxygen/doxygen.git"

  option "with-graphviz", "Build with dot command support from Graphviz."
  option "with-qt5", "Build GUI frontend with Qt support."
  option "with-llvm", "Build with libclang support."

  deprecated_option "with-dot" => "with-graphviz"
  deprecated_option "with-doxywizard" => "with-qt5"
  deprecated_option "with-libclang" => "with-llvm"

  depends_on "cmake" => :build
  depends_on "graphviz" => :optional
  depends_on "qt5" => :optional
  depends_on "llvm" => :optional

  def install
    args = std_cmake_args
    args << "-Dbuild_wizard=ON" if build.with? "qt5"
    args << "-Duse_libclang=ON -DLLVM_CONFIG=#{Formula["llvm"].opt_bin}/llvm-config" if build.with? "llvm"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
