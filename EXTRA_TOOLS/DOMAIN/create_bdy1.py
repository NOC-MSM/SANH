import netCDF4
import numpy as np
dset = netCDF4.Dataset('domain_cfg.nc','r')
dout = netCDF4.Dataset('bathy_meter.nc','a')
[ny,nx] = np.shape(dset.variables['nav_lat'][:])

#e3w = dset.variables['e3w_0'][:].squeeze() # z,y,x
e3t = dset.variables['e3t_0'][:].squeeze() # z,y,x
bathymetry = np.zeros((ny,nx))

bottom_level = dset.variables['bottom_level'][:].squeeze() # y,x
for i in range(nx):
 for j in range(ny):
  bathymetry[j,i] = np.sum(e3t[0:bottom_level[j,i],j,i],0)
   #bathymetry[j,i] = np.sum(e3w[0:bottom_level[j,i],j,i],0)

dout.variables['Bathymetry'][:,:] = np.squeeze(bathymetry)

dset.close()
dout.close()
