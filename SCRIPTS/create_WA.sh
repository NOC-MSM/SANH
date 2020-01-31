cd $FORCING

#The ERA5 fields have been downloaded in livljobs
ln -s $DOMAIN/coordinates.nc $FORCING/.

#load modules
module unload nco cray-netcdf cray-hdf5
module load cray-netcdf-hdf5parallel/4.4.1.1
module load cray-hdf5-parallel/1.10.0.1
module swap PrgEnv-cray PrgEnv-intel/5.2.82

#obtain namelists
cp $GFILE/STARTFILES/FORCING/namelist_reshape_bicubic_atmos $FORCING/.
cp $GFILE/STARTFILES/FORCING/namelist_reshape_bilin_atmos $FORCING/.

#changes in the namelists manually if you have too
#sed -i 's,ERA5_MSL_y2017.nc,/work/n01/n01/annkat/SEAsia_ERSEM_CMEMS/SURFACE_FORCING/ERA5_MSDWLWRF_y2017.nc,g' namelist_reshape_bilin_atmos
#sed -i 's,/work/n01/n01/acc/DFS/DFS5.2/1960/drowned_precip_DFS5.2_y1960.nc,/work/n01/n01/annkat/SEAsia_ERSEM_CMEMS/SURFACE_FORCING/ERA5_MSDWLWRF_y2017.nc,g' namelist_reshape_bicubic_atmos

#generate weights
$TDIR/WEIGHTS/scripgrid.exe namelist_reshape_bilin_atmos
$TDIR/WEIGHTS/scrip.exe namelist_reshape_bilin_atmos
$TDIR/WEIGHTS/scripshape.exe namelist_reshape_bilin_atmos
$TDIR/WEIGHTS/scrip.exe namelist_reshape_bicubic_atmos
$TDIR/WEIGHTS/scripshape.exe namelist_reshape_bicubic_atmos

cd $WORK
