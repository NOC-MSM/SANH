cd $DOMAIN

#cp $GFILE/BATH/gebco_in.nc $DOMAIN
cp $GFILE/BATH/GRIDONE_2008_2D_74.0_-21.0_134.0_25.0.nc $DOMAIN

ncap2 -s 'where(elevation > 0) elevation=0' GRIDONE_2008_2D_74.0_-21.0_134.0_25.0.nc tmp.nc

ncflint --fix_rec_crd -w -1.0,0.0 tmp.nc tmp.nc gebco_in.nc

rm tmp.nc

cd $WORK
