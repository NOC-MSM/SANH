cd $TDIR

cp $GFILE/ARCH/arch-XC_ARCHER_INTEL_NOXIOS.fcm ../ARCH/.
cp $GFILE/ARCH/arch-XC_ARCHER_INTEL_XIOS1.fcm  ../ARCH/.


cd $TDIR/WEIGHTS/src

patch -b < $GFILE/p_files/scripinterp_mod.patch
patch -b < $GFILE/p_files/scripinterp.patch
patch -b < $GFILE/p_files/scrip.patch
patch -b < $GFILE/p_files/scripshape.patch
patch -b < $GFILE/p_files/scripgrid.patch

cd $TDIR

./maketools -n NESTING -m XC_ARCHER_INTEL_NOXIOS -j 6
./maketools -m XC_ARCHER_INTEL_XIOS1 -n DOMAINcfg
./maketools -m XC_ARCHER_INTEL_XIOS1 -n REBUILD_NEMO
./maketools -m XC_ARCHER_INTEL_XIOS1 -n WEIGHTS

cd $SCRIPTS

