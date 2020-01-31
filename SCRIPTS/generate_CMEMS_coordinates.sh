#create coordinates that corresponds to the new fields
module load nco/gcc/4.4.2
ncks -v longitude,latitude,depth,time CMEMS_data/1993/CMEMS_1993_01_01_download.nc  tmp1.nc
ncrename -d time,t -d latitude,y -d longitude,x tmp1.nc
ncap2 -O -s 'glamt[t,y,x]=longitude' tmp1.nc
ncap2 -O -s 'glamu[t,y,x]=longitude' tmp1.nc
ncap2 -O -s 'glamv[t,y,x]=longitude' tmp1.nc
ncap2 -O -s 'gphit[t,y,x]=latitude' tmp1.nc
ncap2 -O -s 'gphiu[t,y,x]=latitude' tmp1.nc
ncap2 -O -s 'gphiv[t,y,x]=latitude' tmp1.nc
mv tmp1.nc CMEMS_subdomain_coordinates.nc

#create masks that corresponds to the new field
#module load nco/gcc/4.4.2.ncwa
module load nco/gcc/4.4.2
ncks -v longitude,latitude,depth,time,so CMEMS_data/1993/CMEMS_1993_01_01_download.nc tmp2.nc
ncks -A -v uo,vo UV_components/1993/CMEMS_1993_01_01_download_UV.nc tmp2.nc
ncatted -a _FillValue,,d,, tmp2.nc
ncap2 -O -s 'where(so>0.) so=1' tmp2.nc tmp2.nc
ncap2 -O -s 'where(so<=0.) so=0' tmp2.nc tmp2.nc
ncap2 -O -s 'where(uo>-10.) uo=1' tmp2.nc tmp2.nc
ncap2 -O -s 'where(uo<=-10.) uo=0' tmp2.nc tmp2.nc
ncap2 -O -s 'where(vo>-10.) vo=1' tmp2.nc tmp2.nc
ncap2 -O -s 'where(vo<=-10.) vo=0' tmp2.nc tmp2.nc
ncrename -d time,t -d latitude,y -d longitude,x tmp2.nc
ncrename -v so,tmask tmp2.nc
ncrename -v uo,umask tmp2.nc
ncrename -v vo,vmask tmp2.nc
mv tmp2.nc CMEMS_subdomain_mask.nc

