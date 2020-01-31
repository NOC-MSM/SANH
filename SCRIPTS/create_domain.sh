cd $TDIR

#cp $GFILE/BATH/namelist_cfg $DOMAIN #overwite the namelist_cfg with the appropriate one you have already created
cp  $DOMAIN/namelist_cfg $TDIR/DOMAINcfg/namelist_cfg

#link coordinates and bathymeter
ln -s $DOMAIN/coordinates.nc $TDIR/DOMAINcfg/.

# choose gebco or ORCA12 bathymetry
#ln -s $DOMAIN/bathy_meter_gebco.nc $TDIR/DOMAINcfg/bathy_meter.nc
ln -s $DOMAIN/bathy_meter_ORCA12.nc $TDIR/DOMAINcfg/bathy_meter.nc

#copy file for z-s hybrid namdom (not sure if necessery)
cp $GFILE/domzgr_jelt_changes.f90 $TDIR/DOMAINcfg/src/domzgz.f90

cd $TDIR/DOMAINcfg

cp $SCRIPTS/job_create.sh $TDIR/DOMAINcfg/job_create.sh
#you have to submit the job_create.sh job to creat the domain_cfg
qsub -q short job_create.sh

#after create copy it and store it for durther use
#cp $TDIR/DOMAINcfg/domain_cfg.nc $DOMAIN/domain_cfg_gebco.nc
#cp $TDIR/DOMAINcfg/domain_cfg.nc $DOMAIN/domain_cfg_ORCA12.nc


cd $DOMAIN
