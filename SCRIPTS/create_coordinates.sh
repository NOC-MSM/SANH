cd $TDIR/NESTING

#cp $GFILE/DOMAIN/namelist.input $DOMAIN #edit if necessary (jenjar93)
cp $DOMAIN/namelist.input $TDIR/NESTING/

 
ln -s $GFILE/DOMAIN/coordinates_ORCA_R12.nc $TDIR/NESTING/.
#cp $GFILE/namelist.input $TDIR/NESTING/

./agrif_create_coordinates.exe

cp 1_coordinates_ORCA_R12.nc $DOMAIN/coordinates.nc

#cp $START_FILES/GRIDO* $INPUTS/.
#cp $START_FILES/namelist_reshape_bilin_gebco $INPUTS/.

cd $SCRIPTS
