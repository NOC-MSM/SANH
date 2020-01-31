%%load data 
clear all
clc

file1 = 'ERA5_LSM_draft.nc';

lon1 = ncread(file1,'lon');
lat1 = ncread(file1,'lat');
LSM = ncread(file1,'LSM');

file2 = 'my_era5_LSM.nc';
lon2 = ncread(file2,'longitude');
lat2 = ncread(file2,'latitude');
nlon = repmat(lon2,1,length(lat2));
nlat = repmat(lat2,1,length(lon2));
nlat = nlat';

%% fill in the anomalous point in the LSM

%ax =
%[104.009360566152,104.569378170672,-3.10733745622746,-2.50607325296504] % SEAsia
ax = [68.9672507568223,69.4003456345541,5.62828909419822,6.16590002157932]; %SANH
indx_lon = find(nlon(:,1) > ax(1) & nlon(:,1) < ax(2));
indx_lat = find(nlat(1,:) > ax(3) & nlat(1,:) < ax(4));

LSM(indx_lon,indx_lat) = 1;

%% create NetCDF

output = 'ERA5_LSM.nc';
x=length(nlon);
y=size(nlon,2);
nccreate(output,'lon', 'Dimensions',{'x',x,'y',y},'Format','classic')
ncwrite(output,'lon',nlon);
nccreate(output,'lat', 'Dimensions',{'x',x,'y',y},'Format','classic')
ncwrite(output,'lat',nlat);
nccreate(output,'LSM','Dimensions',{'x',x,'y',y},'Format','classic')
ncwrite(output,'LSM',LSM);

%% Testing output 
% !! LATITUDE HAS TO BE NEGATIVE - REVERSES ITSELF IN .NC FILE !! - this is
% set in the create_LSM.py script (see Nico's note) 

% clear all; clc
% output = 'ERA5_LSM.nc';
% 
% lon = ncread(output,'lon');
% lat = ncread(output,'lat');
% lsm = ncread(output,'LSM');
% 
% close all
% pcolor(lon,lat,lsm); shading flat;
% 

