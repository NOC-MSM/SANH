clear all
clc

% This programme reads in Salinity data, interpolates on to the NEMO grid
% that you provide and outputs the points on the open boundaries, which you
% will also provide.

% Ingedients needed: 

% 1) domain_cfg.nc         % Your NEMO grid
% 2) bathy_meter.nc        % Your bathymetry file
% 3) coordinates.bdy.nc    % Your coordinates file, generated when tides
% you make tides

% 4) Daily parent data. This has struction ./SAL16_dir/JAN/Sal_16_0000.nc

% This code uses the parallel toolbox. This might have memory restrictions
% based on the computer you are using. If you want this to run quickly, use
% the following syntax: parpool(N) with N = 16 or N=31 if you have the
% resources.

% Note this is adapted only for Copernicus data but can easily adapted for
% other datasets. Email a.brereton@liverpool.ac.uk for help.



% we want to make the current directory visible so we can use subroutines 
addpath(pwd)

% Control variables - make sure 

prefix='INDIAN_bdy_';           % prefix to output filename
output_name='sossheig';         % output variable name
variable_name='zos';         % variable from input file
filename_prefix='SSH';         % e.g. 'INDIAN_bdy_TEMP...'
Input_directory='SSH17_dir';   % Input file directory
year = '2017';                  % e.g. 'INDIAN_bdy_TEMP_y2017...'
grid_data = 'domain_cfg.nc';    % NEMO grid information


%  e.g. 'INDIAN_bdy_SAL_y2017m01.nc'

Input_month_suf{1}='01.nc';
Input_month_suf{2}='02.nc';
Input_month_suf{3}='03.nc';
Input_month_suf{4}='04.nc';
Input_month_suf{5}='05.nc';
Input_month_suf{6}='06.nc';
Input_month_suf{7}='07.nc';
Input_month_suf{8}='08.nc';
Input_month_suf{9}='09.nc';
Input_month_suf{10}='10.nc';
Input_month_suf{11}='11.nc';
Input_month_suf{12}='12.nc';


% Input directory month names e.g. ...../SAL16_dir/JAN/

Input_month{1}='JAN';
Input_month{2}='FEB';
Input_month{3}='MAR';
Input_month{4}='APR';
Input_month{5}='MAY';
Input_month{6}='JUN';
Input_month{7}='JUL';
Input_month{8}='AUG';
Input_month{9}='SEP';
Input_month{10}='OCT';
Input_month{11}='NOV';
Input_month{12}='DEC';



% x co-ordinate indice of boundary 

nbidta = ncread('coordinates.bdy.nc','nbit');   % (yb, xb)





% y co-ordinate indice of boundary 

nbjdta = ncread('coordinates.bdy.nc','nbjt');   % (yb,xb)





% rim level, this code is only set up for a rimwidth of 1.

nbrdta = nbidta*0+1;                            % (yb,xb)



% nav_lon - we have this in domain_cfg (y,x)
% nav_lat - we have this in domain_cfg (y,x)

nav_lon = ncread(grid_data,'nav_lon');
nav_lat = ncread(grid_data,'nav_lat');




% create a land-sea mask from bathymetry

B=ncread('bathy_meter.nc','Bathymetry');

B(B>0)=1;       % 1 is Water
B(isnan(B))=0;  % 0 is Land

bdy_msk=B;






for month=1:12
    


%  e.g. 'INDIAN_bdy_SAL_y2017m01.nc'
    
output_filename = [prefix , filename_prefix , '_y',year,'m',Input_month_suf{month}];



% cd into the data directory
cd(Input_directory)
cd(Input_month{month})
filenames=dir('*.nc');



% This loops through daily files, interpolating onto NEMO grid and 
% getting boundary points for the data.




parfor j=1:length(filenames)
    
           
        [~,Variable_obc] = COPERNICUS_INTERP_SSH(filenames(j).name,grid_data,variable_name,nbidta,nbjdta);
        
        
    
    
    NEMO_variable_obc(:,:,j)=Variable_obc;
    
    
    
    
    % deptht - this is the depths at the boundary points (z, yb, xb)
    % votemper (etc) -                                   (time_counter, z, yb, xb)
    
    time(j)=ncread(  filenames(j).name , 'time');
    time_counter(j) = (time(j) + 18262*24)*3600;  % 18262 days between 1900 and 1950
    
end






cd ../..




% Write out all the relevant variables to monthly file


delete(output_filename)


nccreate(output_filename,'nbrdta',...
    'Dimensions',{'xb',length(nbidta),'yb',1},...
    'Format','netcdf4_classic');

ncwrite(output_filename,'nbrdta',nbrdta);

nccreate(output_filename,'nbidta',...
    'Dimensions',{'xb',length(nbidta),'yb',1},...
    'Format','netcdf4_classic');

ncwrite(output_filename,'nbidta',nbidta);

nccreate(output_filename,'nbjdta',...
    'Dimensions',{'xb',length(nbidta),'yb',1},...
    'Format','netcdf4_classic');

ncwrite(output_filename,'nbjdta',nbjdta);

nccreate(output_filename,'nav_lon',...
    'Dimensions',{'x',size(nav_lon,1),'y',size(nav_lon,2)},...
    'Format','netcdf4_classic');

ncwrite(output_filename,'nav_lon',nav_lon);

nccreate(output_filename,'nav_lat',...
    'Dimensions',{'x',size(nav_lat,1),'y',size(nav_lat,2)},...
    'Format','netcdf4_classic');

ncwrite(output_filename,'nav_lat',nav_lat);

nccreate(output_filename,'bdy_msk',...
    'Dimensions',{'x',size(bdy_msk,1),'y',size(bdy_msk,2)},...
    'Format','netcdf4_classic');

ncwrite(output_filename,'bdy_msk',bdy_msk);

nccreate(output_filename,'time_counter',...
    'Dimensions',{'time_counter',Inf},...
    'Format','netcdf4_classic');

ncwrite(output_filename,'time_counter',time_counter);

nccreate(output_filename,output_name,...
    'Dimensions',{'xb',size(NEMO_variable_obc,1),'yb',1,'time_counter',size(NEMO_variable_obc,3)},...
    'Format','netcdf4_classic');

ncwrite(output_filename,output_name,NEMO_variable_obc);


end