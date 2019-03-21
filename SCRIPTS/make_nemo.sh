svn co http://forge.ipsl.jussieu.fr/nemo/svn/trunk/NEMOGCM@8395 $NEMO/trunk_NEMOGCM_r8395

cp $ARCH/arch-XC_ARCHER_INTEL.fcm $CDIR/../ARCH/

cd $CDIR

printf 'y\nn\nn\nn\nn\nn\nn\nn\n' | ./makenemo -n $CONFIG -m XC_ARCHER_INTEL -j 10

./makenemo -n $CONFIG -m XC_ARCHER_INTEL -j 10 clean


cp $GFILE/f_files/* $CDIR/$CONFIG/MY_SRC/.
cp $GFILE/cpp_file.fcm $CONFIG/cpp_$CONFIG.fcm

./makenemo -n $CONFIG -m XC_ARCHER_INTEL -j 10

cp  $XIOS_DIR/bin/xios_server.exe $EXP/xios_server.exe

cd $WDIR
