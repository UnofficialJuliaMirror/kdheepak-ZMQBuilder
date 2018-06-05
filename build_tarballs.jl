using BinaryBuilder, Compat

# Collection of sources required to build ZMQ
sources = [
    "https://github.com/zeromq/libzmq.git" =>
    "d062edd8c142384792955796329baf1e5a3377cd", # v4.2.5
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libzmq
sh autogen.sh
./configure --prefix=$prefix --host=${target} \
    --without-docs --disable-libunwind --disable-perf \
    --disable-eventfd --without-gcov --disable-curve-keygen
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms() # build on all supported platforms

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libzmq", :libzmq),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "ZMQ", sources, script, platforms, products, dependencies)
