clear all
clc

fname='bathy_meter.nc';

B=ncread(fname,'Bathymetry');
x=ncread(fname,'nav_lon');
y=ncread(fname,'nav_lat');
B(isnan(B))=0;

% make landsea mask
A=-B;
A(A==0)=1;
A(A<0)=0;

% put land border on east coast
A(end,:)=1;

% fill closed spaces
A1=imfill(A,'holes');
B(A1==1)=nan;


% update bathymetry
ncid=netcdf.open(fname,'WRITE');
varid = netcdf.inqVarID(ncid,'Bathymetry');

netcdf.putVar(ncid,varid,B)


