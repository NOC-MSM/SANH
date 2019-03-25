cd $TIDE

# copy a number of grid / tides / namelist and runscript files
#cp $GFILE/TIDAL_FORCING/* .
cp $DOMAIN/bathy_meter.nc .
cp $DOMAIN/domain_cfg.nc .

qsub run_script.pbs

cd $WDIR 

