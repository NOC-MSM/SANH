cd $DOMAIN

cp $GFILE/BATH/* $DOMAIN


$TDIR/WEIGHTS/scripgrid.exe namelist_reshape_bilin_eORCA12
$TDIR/WEIGHTS/scrip.exe namelist_reshape_bilin_eORCA12
$TDIR/WEIGHTS/scripinterp.exe namelist_reshape_bilin_eORCA12
 

ncap2 -s 'where(Bathymetry < 0) Bathymetry=0' bathy_meter.nc tmp1.nc
ncap2 -s 'where(Bathymetry < 10 && Bathymetry > 0) Bathymetry=10' tmp1.nc -O bathy_meter.nc
rm tmp1.nc

cp bathy_meter.nc bathy_meter_ORCA12.nc

#module unload nco cray-netcdf cray-hdf5
#module load cray-netcdf-hdf5parallel
#module load cray-hdf5-parallel

#cp $DOMAIN/coordinates.nc     $TDIR/DOMAINcfg/.
#cp $DOMAIN/bathy_meter.nc     $TDIR/DOMAINcfg/.
#cp $DOMAIN/namelist_cfg  $TDIR/DOMAINcfg/.
#cp $START_FILES/rs.pbs        $TDIR/DOMAINcfg/.
#cp $WDIR/make_paths.sh        $TDIR/DOMAINcfg/.

#cd $TDIR/DOMAINcfg
#qsub  rs.pbs

cd $SCRIPTS
