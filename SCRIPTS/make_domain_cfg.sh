cp $DOMAIN/coordinates.nc     $TDIR/DOMAINcfg/.
cp $DOMAIN/bathy_meter.nc     $TDIR/DOMAINcfg/.
cp /work/n01/n01/jenjar93/BoBEAS/DOMAIN/namelist_cfg  $TDIR/DOMAINcfg/.
cp $GFILE/DOMAIN/rs.pbs        $TDIR/DOMAINcfg/.
#cp $WDIR/make_paths.sh        $TDIR/DOMAINcfg/.
cp $WDIR/../SANH/SCRIPTS/make_paths.sh        $TDIR/DOMAINcfg/.

cd $TDIR/DOMAINcfg
qsub  rs.pbs
