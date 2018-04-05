using BinaryBuilder

# Collection of sources required to build ZMQ
sources = [
    "https://github.com/zeromq/libzmq.git" =>
    "d062edd8c142384792955796329baf1e5a3377cd", # v4.2.5
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libzmq

sh autogen.sh

./configure --prefix=$prefix --host=${target} --without-docs --disable-libunwind --disable-perf --disable-eventfd --without-gcov
make && make install

if [ $target == "x86_64-w64-mingw32" -o $target == "i686-w64-mingw32" ]; then
    mkdir -p $prefix/bin
    mv $prefix/lib/*.dll $prefix/bin
fi
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc),
    Linux(:powerpc64le, :glibc),
    Windows(:x86_64),
    Windows(:i686),
    MacOS()
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libzmq", :libzmq),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "ZMQ", sources, script, platforms, products, dependencies)
