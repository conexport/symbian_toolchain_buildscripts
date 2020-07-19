# Symbian toolchain autobuild script
This repository provides an easy and cleanup way to build GCCE compilers for SymbianELF.

## Requirements (Host machine)
- A C++ compiler (tested with gcc)
- zlib
- cloog
- libelf
- wget
- tar
- gmp
- mpfr
- mpc

## Usage
Set the environment variable `EKA_TOOLCHAIN` to the folder where the toolchains will be stored (modify your init script like .bashrc):

`export EKA_TOOLCHAIN=/opt/eka2/gcc`

Type `./build-gcce.sh` to build the toolchain.

## What will be installed?
- GNU Bintuils for Symbianelf
- GCC for Symbianelf

## Why the mainstream GCC version is not used?
While GCC and Bintuils does support the Symbian platform (arm-none-symbianelf), it is currently unaware what
patches did CodeSourcery version of GCC does have that current GCC does not have.

Future investigation is needed in order to bring support for last GCC and Binutils.

## References
- [CodeBench Lite 2012 (Toolchain used)](https://sourcery.mentor.com/GNUToolchain/release2133)
