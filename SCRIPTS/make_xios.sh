cd $WORK

svn co -r1242 http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/trunk $XIOS_DIR
cd $XIOS_DIR

cp $ARCH/arch-XC30_ARCHER* arch/.

./make_xios --full --prod --arch XC30_ARCHER --netcdf_lib netcdf4_par

ln -s  $XIOS_DIR  $WORK/XIOS

cd $WDIR
