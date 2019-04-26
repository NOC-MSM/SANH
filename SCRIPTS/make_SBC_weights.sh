cd $SBC/FORCING

cp $GFILE/SURFACE_FORCING/namelist_reshape_bicubic_atmos .
cp $GFILE/SURFACE_FORCING/namelist_reshape_bilin_atmos .
cp $DOMAIN/coordinates.nc .


$TDIR/WEIGHTS/scripgrid.exe namelist_reshape_bilin_atmos
$TDIR/WEIGHTS/scrip.exe namelist_reshape_bilin_atmos
$TDIR/WEIGHTS/scripshape.exe namelist_reshape_bilin_atmos

$TDIR/WEIGHTS/scripgrid.exe namelist_reshape_bicubic_atmos
$TDIR/WEIGHTS/scrip.exe namelist_reshape_bicubic_atmos
$TDIR/WEIGHTS/scripshape.exe namelist_reshape_bicubic_atmos

cd $WDIR
