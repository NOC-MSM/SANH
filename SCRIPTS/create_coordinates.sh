cd $TDIR/NESTING


ln -s $GFILE/DOMAIN/rotated/coordinates_ORCA_R12.nc $TDIR/NESTING/.
#cp $GFILE/DOMAIN/namelist.input $DOMAIN/ #this copies over the original namelist file for editing
cp /work/n01/n01/jenjar93/BoBEAS/DOMAIN/namelist.input $TDIR/NESTING/

./agrif_create_coordinates.exe

cp 1_coordinates_ORCA_R12.nc $DOMAIN/coordinates.nc


#cp $START_FILES/GRIDO* $INPUTS/.
#cp $START_FILES/namelist_reshape_bilin_gebco $INPUTS/.

cd $WDIR
