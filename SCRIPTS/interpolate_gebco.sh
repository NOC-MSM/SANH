cd $DOMAIN

cp $GITCLONE/START_FILES/DOMAINcfg/namelist_reshape_bilin_gebco $DOMAIN

$TDIR/WEIGHTS/scripgrid.exe namelist_reshape_bilin_gebco
$TDIR/WEIGHTS/scrip.exe namelist_reshape_bilin_gebco
$TDIR/WEIGHTS/scripinterp.exe namelist_reshape_bilin_gebco

cp bathy_meter.nc bathy_meter_gebco.nc
#module unload cray-netcdf-hdf5parallel cray-hdf5-parallel
#module load cray-netcdf cray-hdf5
#module load nco/4.5.0
#ncap2 -s 'where(Bathymetry < 0) Bathymetry=0' bathy_meter.nc tmp.nc
#ncap2 -s 'where(Bathymetry < 10 && Bathymetry > 0) Bathymetry=10' tmp.nc bathy_meter.nc
#rm tmp.nc


#module unload nco cray-netcdf cray-hdf5
#module load cray-netcdf-hdf5parallel
#module load cray-hdf5-parallel


#cp $INPUTS/coordinates.nc     $TDIR/DOMAINcfg/.
#cp $INPUTS/bathy_meter.nc     $TDIR/DOMAINcfg/.
#cp $START_FILES/namelist_cfg  $TDIR/DOMAINcfg/.
#cp $START_FILES/rs.pbs        $TDIR/DOMAINcfg/.
#cp $WDIR/make_paths.sh        $TDIR/DOMAINcfg/.

#cd $TDIR/DOMAINcfg
#qsub  rs.pbs

cd $WORK
