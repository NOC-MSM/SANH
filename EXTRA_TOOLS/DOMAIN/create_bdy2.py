import netCDF4
import numpy as np
dset = netCDF4.Dataset('bdy_mask.nc','a')
[ny,nx] = np.shape(dset.variables['mask'][:])
for i in range(nx):
  if dset.variables['mask'][1,i] == 1:
    dset.variables['mask'][0,i] = -1
  else:
    dset.variables['mask'][0,i] = 0

for j in range(ny):
  if dset.variables['mask'][j,1] == 1:
    dset.variables['mask'][j,0] = -1
  else:
    dset.variables['mask'][j,0] = 0

dset.close()
