cd $XIOS

svn checkout -r 1566 http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/branchs/xios-2.5 $XIOS_DIR
cd $XIOS_DIR

#you may need another architecture file as this one is configured for use in ARCHER. A list of architecture files available can be found at $XIOS_DIR/arch

cp $GFILE/arch_xios/arch-XC30_ARCHER* arch/.

#make xios
./make_xios  --arch XC30_ARCHER --full --job 4


cd $SCRIPTS
