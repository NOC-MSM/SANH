clear all
clc

% This programme takes Temperature from an input grid, treats it so all
% nans are replaced by interpolated or nearest neighbour values and then
% interpolates this on to the NEMO grid

% Note, interpolation around land is a dark art - this may not give a
% stable solution, but it at least works for me.

% 24/04/19 - Ashley Brereton


fname = 'initcd_votemper.nc';    % name of output file
fname_data = 'Temp_16_0000.nc';  % name of input file
z_data = 'domain_cfg.nc';        % grid file
 

% The input data is a regular grid. The co-ordinates are 1D vectors and the
% variable is F(x,y,z,t). Later in this code, we make our co-ordinates each
% a function of F(x,y,z) with meshgrid. If your data is in NEMO format,
% replicate how (xout,yout,zout) are made for (xin,yin,zin).


% Read in input variables 

Tin=ncread(fname_data,'thetao');  
xin=double(ncread(fname_data,'longitude'));
yin=double(ncread(fname_data,'latitude'));
zin=double(ncread(fname_data,'depth'));
Tin=permute(Tin,[2 1 3]);


% Read output grid information 

xout=double(ncread(z_data,'nav_lon'));
yout=double(ncread(z_data,'nav_lat'));
dzout=ncread(z_data,'e3t_0');

% need all grid variables as F(x,y,z) as this is what is needed by griddata

xout=repmat(xout,1,1,size(dzout,3));
yout=repmat(yout,1,1,size(dzout,3));

% pre-allocate matrix
zout=zeros(size(dzout,1),size(dzout,2),size(dzout,3));




% Build z from dz given in grid file

for i=1:size(dzout,3)
    
    if i==1
        zout(:,:,i)=dzout(:,:,i);
    else
        zout(:,:,i)=zout(:,:,i-1)+dzout(:,:,i);
    end
        
end


% fix surface depth to 0

zin(1)=0;


% make all input grid information F(x,y,z)
[Xin,Yin,Zin]=meshgrid(xin,yin,zin);


% Remove all nan points.
Xlr=Xin(~isnan(Tin));
Ylr=Yin(~isnan(Tin));
Zlr=Zin(~isnan(Tin));
Tlr=Tin(~isnan(Tin));


% Interpolate input on to whole input grid - getting rid of nans
Tin=griddata(Xlr,Ylr,Zlr,Tlr,Xin,Yin,Zin);


% All the nans that couldn't be filled on the input grid, we replace with
% nearest neighbours.

ind_nnan=~isnan(Tin(:));
ind_nan = isnan(Tin(:));

Xlnnan=Xin(ind_nnan);
Ylnnan=Yin(ind_nnan);
Zlnnan=Zin(ind_nnan);
coordnnan=[Xlnnan Ylnnan Zlnnan];

Xlnan=Xin(ind_nan);
Ylnan=Yin(ind_nan);
Zlnan=Zin(ind_nan);
coordnan=[Xlnan Ylnan Zlnan];

ind=knnsearch(coordnnan,coordnan);

T_TEMP=Tin(ind_nnan);
T_TEMP=T_TEMP(ind);


Tin(isnan(Tin))=T_TEMP;



% Then we interpolate fully treated input grid on to our domain.

Tinterp=interp3(xin,yin,zin,Tin,xout,yout,zout);


% converts days since 1900 to seconds since 1950...
time=ncread(  fname_data , 'time');
time_counter = (time + 18262*24)*3600;  % 18262 days between 1900 and 1950



% write all the variables to file

delete(fname)
nccreate(fname,'nav_lon',...
    'Dimensions',{'x',size(xout,1),'y',size(yout,2)},...
    'Format','netcdf4_classic');
ncwrite(fname,'nav_lon',nav_lon);


nccreate(fname,'nav_lat',...
    'Dimensions',{'x',size(xout,1),'y',size(yout,2)},...
    'Format','netcdf4_classic');
ncwrite(fname,'nav_lat',nav_lat);


nccreate(fname,'time_counter',...
    'Dimensions',{'time_counter',Inf},...
    'Format','netcdf4_classic');
ncwrite(fname,'time_counter',time_counter);


nccreate(fname,'gdept',...
    'Dimensions',{'x',size(zout,1),'y',size(zout,2),'z',size(zout,3)},...
    'Format','netcdf4_classic');
ncwrite(fname,'gdept',z);


nccreate(fname,'votemper',...
    'Dimensions',{'x',size(zout,1),'y',size(zout,2),'z',size(zout,3),'time_counter',1},...
    'Format','netcdf4_classic');
ncwrite(fname,'votemper',Tinterp);


