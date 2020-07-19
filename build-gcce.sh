#!/bin/sh
# Automatic build of CodeSourcery for Symbian

auto_conf() {
	rm -rf build/$1
	mkdir build/$1
	cd build/$1
	if ! ../../dist/$1/configure ${*:2} ; then
		echo '>>> FAILED <<<'
		cd ../../
		exit 1
	fi
	if ! make install ; then
		echo '>>> FAILED <<<'
		cd ../../
		exit 1
	fi
	echo 'OK' > ../$1.cache
	cd ../../
}

if [ -z ${EKA_TOOLCHAIN+x} ]; then
	echo Please set 'EKA_TOOLCHAIN' environment variable
	exit 1
fi

export TOOLCHAIN_VERSION=$(git rev-parse --short HEAD)
ret=$?
if [ $? -ne 0 ]; then
	export TOOLCHAIN_VERSION='Unknown'
fi

mkdir build > /dev/null
mkdir dist > /dev/null

# PPL1.2 is not detected in the eyes of GCCE
#echo [001] Parma Polyhedra Library
#if [ -f "dist/ppl-1.2.tar.bz2" ]; then
#	echo Downloading Parma Polyhedra Library
#	wget -P dist https://www.bugseng.com/products/ppl/download/ftp/releases/1.2/ppl-1.2.tar.bz2
#	exit_if_fail .
#fi
#
#if ! [ -d "dist/ppl-1.2" ]; then
#	echo Extracting Parma Polyhedra Library
#	tar -C dist -xvzf dist/ppl-1.2.tar.bz2
#fi
#
#if ! [ -f "build/ppl-1.2.cache" ]; then
#	echo Building Parma Polyhedra Library
#	auto_conf ppl-1.2 --disable-shared --disable-nls --disable-watchdog --with-gmp -without-java
#fi

# Main toolchain sources

echo [001] Sourcery CodeBench Lite distribution
if ! [ -f "dist/arm-2012.03-42-arm-none-symbianelf.src.tar.bz2" ]; then
	echo Downloading Sourcery CodeBench Lite
	wget -P dist https://sourcery.mentor.com/GNUToolchain/package10152/public/arm-none-symbianelf/arm-2012.03-42-arm-none-symbianelf.src.tar.bz2
	exit_if_fail .
fi

if ! [ -d "dist/arm-2012.03-42-arm-none-symbianelf" ]; then
	echo Extracting Sourcery CodeBench Lite
	tar -C dist -xvzf dist/arm-2012.03-42-arm-none-symbianelf.src.tar.bz2
fi

echo [002] Parma Polyhedra Library
if ! [ -d "dist/ppl-0.11" ]; then
	echo Extracting Parma Polyhedra Library
	tar -C dist -xvzf dist/arm-2012.03-42-arm-none-symbianelf/ppl-2012.03-42.tar.bz2
fi

if ! [ -f "build/ppl-0.11.cache" ]; then
	echo Building Parma Polyhedra Library
	auto_conf ppl-0.11 --disable-shared --disable-nls --disable-watchdog --with-gmp -without-java
fi
	
echo [003] binutils
if ! [ -d "dist/binutils-2012.03" ]; then
	echo Extracting binutils
	tar -C dist -xvzf dist/arm-2012.03-42-arm-none-symbianelf/binutils-2012.03-42.tar.bz2
fi

if ! [ -f "build/binutils-2012.03.cache" ]; then
	echo Building binutils
	auto_conf binutils-2012.03 '--prefix=$EKA_TOOLCHAIN' --target=arm-none-symbianelf '--with-pkgversion=Compatible Symbian^3 binutils $TOOLCHAIN_VERSION (Sourcery CodeBench Lite 2012.03-42)' --with-bugurl=https://github.com/conexport/symbian_toolchain_buildscripts --disable-nls --enable-poison-system-directories
fi

echo [004] GCC
if ! [ -d "dist/gcc-4.6-2012.03" ]; then
	echo Extracting gcc
	tar -C dist -xvzf dist/arm-2012.03-42-arm-none-symbianelf/gcc-2012.03-42.tar.bz2
fi

if ! [ -f "build/gcc-4.6-2012.03.cache" ]; then
	echo Building gcc
	auto_conf gcc-4.6-2012.03 '--with-pkgversion=Compatible Symbian^3 GCC $TOOLCHAIN_VERSION (Sourcery CodeBench Lite 2012.03-42)' '--prefix=$EKA_TOOLCHAIN' --disable-nls '--with-host-libstdcxx=-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm' --with-cloog --enable-poison-system-directories --with-mpc --with-gmp --with-mpfr --target=arm-none-symbianelf --with-bugurl=https://github.com/conexport/symbian_toolchain_buildscripts --enable-threads--disable-libmudflap --disable-libssp --enable-extra-sgxxlite-multilibs --with-gnu-as --with-gnu-ld '--with-specs=%{save-temps: -fverbose-asm} -D__CS_SOURCERYGXX_MAJ__=2012 -D__CS_SOURCERYGXX_MIN__=3 -D__CS_SOURCERYGXX_REV__=42 %{O2:%{!fno-remove-local-statics: -fremove-local-statics}} %{O*:%{O|O0|O1|O2|Os:;:%{!fno-remove-local-statics: -fremove-local-statics}}}' --enable-languages=c,c++ --enable-shared --enable-lto --disable-hosted-libstdcxx
fi
