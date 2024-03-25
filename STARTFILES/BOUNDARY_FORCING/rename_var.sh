for var in M2 S2 O1 K1 K2 N2 L2 NU2 M4 MS4 Q1 P1 S1 2N2 MU2 #edit the the constituents
do
 echo $var
        mv 'OUTPUT/SANH_FES14_bdytide_FES2014_'$var'_grd_U.nc' 'OUTPUT/SANH_bdytide_'$var'_grid_U.nc'
        mv 'OUTPUT/SANH_FES14_bdytide_FES2014_'$var'_grd_V.nc' 'OUTPUT/SANH_bdytide_'$var'_grid_V.nc'
        mv 'OUTPUT/SANH_FES14_bdytide_FES2014_'$var'_grd_Z.nc' 'OUTPUT/SANH_bdytide_'$var'_grid_T.nc'


done
