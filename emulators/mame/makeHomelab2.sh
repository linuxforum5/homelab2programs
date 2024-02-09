rm homelab2
make SUBTARGET=homelab2 SOURCES=src/mame/homelab/homelab.cpp
# make TARGETOS=windows PTR64=0 CROSS_BUILD=1 NOWERROR=1 OVERRIDE_CC=i686-w64-mingw32-gcc OVERRIDE_CXX=i686-w64-mingw32-g++ OVERRIDE_LD=i686-w64-mingw32-gcc-ld MINGW32=/usr/** AR=ar SUBTARGET=homelab2 SOURCES=src/mame/homelab/homelab.cpp
