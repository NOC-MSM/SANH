clear all
clc

% Programme to find nearest coastal wet point to river source.

% River data is

river_fname = '../DATA/coastal-stns-Vol-monthly.updated-oct2007.nc';

% NEMO bathymetry file is...

bathy_fname='../DATA/bathy_meter.nc';
coord_fname='../DATA/coordinates.nc';

sc= (1000^3)/(365*86400);

flow=ncread(river_fname,'vol_stn');
m2s=ncread(river_fname,'ratio_m2s');

flw=flow.*m2s.*sc;
lonr=ncread(river_fname,'lon_mou');
latr=ncread(river_fname,'lat_mou');



lon_nemo=ncread(bathy_fname,'nav_lon');
lat_nemo=ncread(bathy_fname,'nav_lat');

e1t=ncread(coord_fname,'e1t');
e2t=ncread(coord_fname,'e2t');




border=0.5; % don't accept rivers around the border of a certain width



ind=lonr < (min(lon_nemo(:))+border);

lonr=lonr(~ind);
latr=latr(~ind);
flw=flw(~ind);



ind= lonr > (max(lon_nemo(:))-border);

lonr=lonr(~ind);
latr=latr(~ind);
flw=flw(~ind);



ind=latr < (min(lat_nemo(:))+border);

lonr=lonr(~ind);
latr=latr(~ind);
flw=flw(~ind);



ind= latr > (max(lat_nemo(:))-border);

lonr=lonr(~ind);
latr=latr(~ind);
flw=flw(~ind);



[lon_coast,lat_coast,coastal]=Coast_finder(bathy_fname);
coastal=find(coastal);


[id,D]=knnsearch([lon_coast lat_coast],[lonr latr]);


% Let's make an upper limit of a distance of 5 degrees

upper_limit=5;

id=id(D<upper_limit);
coastal=coastal(D<upper_limit);



rho0=1000;
nx=size(lon_nemo,1);
ny=size(lon_nemo,2);
rorunoff=zeros(nx,ny);


rorunoff(coastal(1))=flw(1)*rho0/(e1t(coastal(1))*e2t(coastal(1)));

for i=2:length(id)
    
    runoff=flw(i)*rho0/(e1t(coastal(i))*e2t(coastal(i)));
    
    if coastal(i) == coastal(i-1)
        
        rorunoff(coastal(i))=runoff+rorunoff(coastal(i-1));
        
    else
        
        rorunoff(coastal(i))=runoff;
        
    end
    
    
end

rorunoff=repmat(rorunoff,1,1,12);


delete('river_test.nc');
output='river_test.nc';
nccreate(output,'time_counter','Dimensions',{'time_counter',Inf},'Format','netcdf4_classic');
nccreate(output,'lat','Dimensions',{'lat',ny},'Format','netcdf4_classic');
nccreate(output,'lon','Dimensions',{'lon',nx},'Format','netcdf4_classic');
nccreate(output,'rorunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
ncwrite(output,'lon',(1:nx));
ncwrite(output,'lat',(1:ny));
ncwrite(output,'rorunoff',rorunoff);
ncwrite(output,'time_counter',(1:12));

