#------------------Script to create bdy_mask.nc from bathymetry--------------


module load anaconda/2.1.0
module load nco

python create_bdy1.py


rm -f bdy_mask.nc tmp[12].nc
ncks -v top_level domain_cfg.nc tmp1.nc
ncrename -h -v top_level,mask tmp1.nc tmp2.nc
ncwa -a t tmp2.nc bdy_mask.nc
rm -f tmp[12].nc


python create_bdy2.py



