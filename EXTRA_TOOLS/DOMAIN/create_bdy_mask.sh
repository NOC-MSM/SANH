#------------------Script to create bdy_mask.nc from bathymetry--------------

cp $GFILE/DOMAIN/create* $DOMAIN

cd $DOMAIN

module load anaconda
module load nco

python create_bdy1.py


rm -f bdy_mask.nc tmp[12].nc
ncks -v top_level domain_cfg.nc tmp1.nc
ncrename -h -v top_level,mask tmp1.nc tmp2.nc
ncwa -a t tmp2.nc bdy_mask.nc
rm -f tmp[12].nc


python create_bdy2.py

cp bdy_mask.nc $OBC

cd $WOR

