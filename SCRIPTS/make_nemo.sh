cd $NEMO

svn co http://forge.ipsl.jussieu.fr/nemo/svn/trunk/NEMOGCM@8395 trunk_NEMOGCM_r8395

cp $GFILE/ARCH/arch-XC_ARCHER_INTEL.fcm $CDIR/../ARCH/


cd $CDIR

#the below command will fail but its ok
printf 'y\nn\nn\nn\nn\nn\nn\nn\n' | ./makenemo -n $CONFIG -m XC_ARCHER_INTEL -j 10

#continue with...
./makenemo -n $CONFIG -m XC_ARCHER_INTEL -j 10 clean

#copy over files 

cp $GFILE/f_files/* $CDIR/$CONFIG/MY_SRC/.
cp $WORK/MY_SRC/* $CDIR/$CONFIG/MY_SRC/.
cp $GFILE/cpp_SANH.fcm $CONFIG/cpp_$CONFIG.fcm


#make nemo
./makenemo -n $CONFIG -m XC_ARCHER_INTEL -j 10

cp  $XIOS_DIR/bin/xios_server.exe $EXP/xios_server.exe
cp $CDIR/$CONFIG/EXP00/* $EXP/

cd $SCRIPTS
