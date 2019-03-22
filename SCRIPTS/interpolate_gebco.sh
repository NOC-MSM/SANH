cd $DOMAIN



cp $GFILE/DOMAIN/namelist_reshape_bilin_gebco $DOMAIN


$TDIR/WEIGHTS/scripgrid.exe namelist_reshape_bilin_gebco
$TDIR/WEIGHTS/scrip.exe namelist_reshape_bilin_gebco
$TDIR/WEIGHTS/scripinterp.exe namelist_reshape_bilin_gebco

#cp $INPUTS/coordinates.nc     $TDIR/DOMAINcfg/.
#cp $INPUTS/bathy_meter.nc     $TDIR/DOMAINcfg/.
#cp $START_FILES/namelist_cfg  $TDIR/DOMAINcfg/.
#cp $START_FILES/rs.pbs        $TDIR/DOMAINcfg/.
#cp $WDIR/make_paths.sh        $TDIR/DOMAINcfg/.

#cd $TDIR/DOMAINcfg
#qsub  rs.pbs

cd $WDIR
