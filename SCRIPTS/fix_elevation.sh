cd $DOMAIN

cp $GFILE/DOMAIN/$BATHY $DOMAIN



ncks -d longitude,60.,110. -d latitude,0.,30. $BATHY cutdown_bathy.nc

ncap2 -s 'where(depth > 0) depth=0' cutdown_bathy.nc tmp.nc

ncflint --fix_rec_crd -w -1.0,0.0 tmp.nc tmp.nc bathy_in.nc

rm tmp.nc
rm $BATHY
rm cutdown_bathy.nc

cd $WDIR
