%% Script to interpolate yearly precipitation onto GlobalNEWS catchments

% This script takes 360 days (= 1year in HADGEM), and interpolates it onto
% a mask file. The amount of precipitation that fell onto the catchment
% over the year is then MEANED
clear all; clc
tic
addpath('C:\Users\jenjar\Desktop\GlobalNEWS2modelcode\user_defined_inputs\GlobalNEWS2ModeledExports_RH2000-version1.0.1');
addpath('C:\Users\jenjar\Desktop\GlobalNEWS2modelcode\user_defined_inputs\accord_clim_run');
addpath('C:\Users\jenjar\Desktop\GlobalNEWS2modelcode\user_defined_inputs\accord_clim_run\precip_data');
clear all; clc


% load precip data (e.g. Hadgem - because of the dodge climatological year,
% I'm doing them all in large chunks)

file1 = 'pr_day_HadGEM2-ES_historical_r3i1p1_19791201-19891130.nc'; %1989
time = ncread(file1,'time'); %change vars accordingly
precip_full = ncread(file1,'pr');
lat = ncread(file1,'lat');
lon = ncread(file1,'lon');


file2 = 'pr_day_HadGEM2-ES_historical_r3i1p1_19891201-19991130.nc'; %1999
time2 = ncread(file2,'time'); %change vars accordingly
precip_full2 = ncread(file2,'pr');
lat2 = ncread(file2,'lat');
lon2 = ncread(file2,'lon');
% 
% time2 = cat(1,time,time2);
% precip_full = cat(3,precip_full,precip_full2);


% 
% 
file3 = 'pr_day_HadGEM2-ES_historical_r3i1p1_19991201-20051230.nc' %2005
time3 = ncread(file3,'time');
precip_full3 = ncread(file3,'pr');
lat3 = ncread(file3,'lat');
lon3 = ncread(file3,'lon');

%  time2 = cat(1,time,time2,time3);
%  precip_full = cat(3,precip_full,precip_full2,precip_full3);

% 
% file4 = 'pr_day_HadGEM2-ES_rcp85_r3i1p1_20051201-20151130.nc' %2015
% time4 = ncread(file4,'time');
% precip_full4 = ncread(file4,'pr');
% lat4 = ncread(file4,'lat');
% lon4 = ncread(file4,'lon');
% % 
% file5 = 'pr_day_HadGEM2-ES_rcp85_r3i1p1_20151201-20251130.nc' %2025
% time5 = ncread(file5,'time');
% precip_full5 = ncread(file5,'pr');
% lat5 = ncread(file5,'lat');
% lon5 = ncread(file5,'lon');
%
% file6 = 'pr_day_HadGEM2-ES_rcp85_r3i1p1_20551201-20651130.nc' %2065
% time6 = ncread(file6,'time');
% precip_full6 = ncread(file6,'pr');
% lat6 = ncread(file6,'lat');
% lon6 = ncread(file6,'lon');
% % 
% file7 = 'pr_day_HadGEM2-ES_rcp85_r3i1p1_20651201-20751130.nc' %2075
% time7 = ncread(file7,'time');
% precip_full7 = ncread(file7,'pr');
% lat7 = ncread(file7,'lat');
% lon7 = ncread(file7,'lon');
% % 
% file9 = 'pr_day_HadGEM2-ES_rcp85_r3i1p1_20751201-20851130.nc' %2085
% time9 = ncread(file9,'time');
% precip_full9 = ncread(file9,'pr');
% lat9 = ncread(file9,'lat');
% lon9 = ncread(file9,'lon');
% % 
% file10 = 'pr_day_HadGEM2-ES_rcp85_r3i1p1_20851201-20951130.nc' %2095
% time10 = ncread(file10,'time');
% precip_full10 = ncread(file10,'pr');
% lat10 = ncread(file10,'lat');
% lon10 = ncread(file10,'lon');
% % 
% file11 = 'pr_day_HadGEM2-ES_rcp85_r3i1p1_20951201-21001130.nc' %2100
% time11 = ncread(file11,'time');
% precip_full11 = ncread(file11,'pr');
% lat11 = ncread(file11,'lat');
% lon11 = ncread(file11,'lon');
% 
time2 = cat(1,time,time2,time3);
precip_full = cat(3,precip_full,precip_full2,precip_full3);


% % cut precip domain
% % ax = [19.4915638606676,164.508798984035,-53.2800000000000,62.4000000000000]; %SEAsia
% ax = [49.6314538043478,109.189198369565,-1.96721311475410,39.6721311475410]; %SANH
% cut_lon = find(lon> ax(1) & lon < ax(2));
% cut_lat = find(lat > ax(3) & lat < ax(4));
% 
% lon = lon(cut_lon);
% lat = lat(cut_lat);
% precip_full = precip_full(cut_lon,cut_lat,:);

%% The below code loops through each of the 5 years included in the precip data
% Output files should be runoff, Q and precip for each catchment for each
% of the 5 years 


%%

% indx1 = [1471:360:19470];%[31:360:1831]; %Takes the last 30 days to create a full year from 1
% indx = [1830:360:19470];%[390:360:1831]; 

 indx1 = [31:360:length(precip_full)];%[31:360:1831]; %Takes the last 30 days to create a full year from 1
 indx = [390:360:length(precip_full)];%[390:360:1831]; 


% indx1 = [31:360:3631]; %Takes the last 30 days to create a full year from 1
% indx = [390:360:3631]; 


for i = 1:length(indx)
    
precip = precip_full(:,:,indx1(i):indx(i));


%% Add a scaling factor for precipitation (needs to be mm/yr)
rho0 = 1000; % for unit conversion
t = precip;
t = t ./ rho0; % kg m-2 s-1 --> m/s
t = t*1000; %m/s --> mm/s
secs = 365*24*3600; %mm/s --> mm/yr
t = t.*secs;
precip = t; %m s-1;


%% load catchment data (GlobalNEWS shapefile)
file = 'NEWS2basins.shp';
S = shaperead(file);

jj = 0.5; % grid resolution

for n = 1:length(S)
    

%load shapefile into matlab -------------------------------------------    

clear shp_res lon_data lat_data mat_data lon1 lat1 mask p_mask cut_precip 
clear lon2 R iprecip
shp_res = S(n);
x1 = round(shp_res.BoundingBox(1,1))-1;
x2 = round(shp_res.BoundingBox(2,1))+1;
y1 = round(shp_res.BoundingBox(1,2))-1;
y2 = round(shp_res.BoundingBox(2,2))+1;

% get the length of the lon lat based on user-defined resolution--------
[lon_data, lat_data]=meshgrid(x1:jj:x2,y1:jj:y2);
lon1(:,1) = lon_data(1,:); lat1(:,1) = lat_data(:,1);
x4 = length(lon1); y4 = length(lat1);
Z = randn(x4,y4);

% create the mask file -------------------------------------------------
R = makerefmat('RasterSize',size(Z'),'Lonlim',[x1 x2],'Latlim',[y1 y2]);
mat_data = vec2mtx(shp_res.Y,shp_res.X,Z',R,'filled');


ibad = find(mat_data == 0);
mat_data(ibad) = 1;
clear ibad; 
ibad = find(mat_data == 2);
mat_data(ibad) = 0;

lon_data = lon_data';
lat_data = lat_data';


% Precipitation est----------------------------------------------------

lon2 = (lon_data(:,1));
lat2 = lat_data(1,:);

[iprecip] = precip_interp(lon,lat,precip,lon2,lat2);

max_lon = max(lon2); 
max_lat = max(lat2); 
min_lon = min(lon2);
min_lat = min(lat2);


%cut_precip domain------------------------------------------------------

indx_lon = find(lon2 >= min_lon & lon2  <= max_lon);
indx_lat = find(lat2 >= min_lat & lat2  <= max_lat);
 
% ignore the catchments that aren't in the domain ----------------------
if isempty(indx_lon) 
    p_yearly(n) = nan;
elseif isempty(indx_lat)
    p_yearly(n) = nan;
else
        
cut_precip = iprecip(indx_lon,indx_lat,:);
 
mask = find(mat_data == 1);

%Mean the precip in that catchment for each time step ----------------


 for m = 1:length(cut_precip)
    
        p = squeeze(cut_precip(:,:,m));
        
        if mask(end)> (size(p,1)*size(p,2)) % removes incomplete catchments
            p_mask(m) = nan;
        else
        p_mask(m) = nanmean(p(mask));
        end 
 end 
    
% Add up all the precip to get a yearly estimate for each catchment -----

p_yearly(n) = nanmean(p_mask); 

clear p_mask p
disp(n)

end 
end 

p_year(:,i) = p_yearly';

[runoff(:,i),Qact(:,i),Qnat(:,i)] = hydro(p_year(:,i));


end 
