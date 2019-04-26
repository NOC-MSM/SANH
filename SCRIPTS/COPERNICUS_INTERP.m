function [Variable_obc,z_obc] = COPERNICUS_INTERP(fname_data,z_data,variable_name,nbidta,nbjdta)




%variable_name='so';
%fname_data = 'Sal_16_0000.nc';
%z_data = 'domain_cfg.nc';





% This is the NEMO grid

xout=double(ncread(z_data,'nav_lon'));
yout=double(ncread(z_data,'nav_lat'));
dzout=ncread(z_data,'e3t_0');

% make x and y 3D array - this is because griddata needs it in this form
xout=repmat(xout,1,1,size(dzout,3));
yout=repmat(yout,1,1,size(dzout,3));



% Here we read in the copernicus data

Variable_in=ncread(fname_data,variable_name);
xin=double(ncread(fname_data,'longitude'));
yin=double(ncread(fname_data,'latitude'));
zin=double(ncread(fname_data,'depth'));
Variable_in=permute(Variable_in,[2 1 3]);




% Build z (e3t_0 just gives dz)
z=zeros(size(dzout,1),size(dzout,2),size(dzout,3));

for i=1:size(dzout,3)
    
    
    if i==1
        z(:,:,i)=dzout(:,:,i);
    else
        z(:,:,i)=z(:,:,i-1)+dzout(:,:,i);
    end
    
    
    
end

zin(1)=0;
%zin(end)=max(z(:))+1;



% make COPERNICUS coordinates 3D arrays (for griddata function)
[Xin,Yin,Zin]=meshgrid(xin,yin,zin);


% We only want to feed non-nan numbers from the copernicus grid.
Xlr=Xin(~isnan(Variable_in));
Ylr=Yin(~isnan(Variable_in));
Zlr=Zin(~isnan(Variable_in));
Variable_lr=Variable_in(~isnan(Variable_in));


% Interpolate Copernicus grid (without nans) on to same grid - basically
% "flood filling", but by interpolation, not extrapolation.

Variable_in=griddata(Xlr,Ylr,Zlr,Variable_lr,Xin,Yin,Zin);

clear Variable_lr Xlr Ylr Zlr

% nans will still exists around the edges - let's find the nearest
% neighours to fill them in.

ind_nnan=~isnan(Variable_in(:));
ind_nan = isnan(Variable_in(:));

Xlnnan=Xin(ind_nnan);
Ylnnan=Yin(ind_nnan);
Zlnnan=Zin(ind_nnan);
coordnnan=[Xlnnan Ylnnan Zlnnan];

Xlnan=Xin(ind_nan);
Ylnan=Yin(ind_nan);
Zlnan=Zin(ind_nan);
coordnan=[Xlnan Ylnan Zlnan];


clear Xin Yin Zin Xlnan Ylnan Zlnan Xlnnan Ylnnan Zlnnan

% I found you!
ind=knnsearch(coordnnan,coordnan);

clear coordnan coordnnan

% tricky to read, but these 3 lines replace nans with nearest neighbours.
% Trust me.

Variable_TEMP=Variable_in(ind_nnan);
Variable_TEMP=Variable_TEMP(ind);
Variable_in(isnan(Variable_in))=Variable_TEMP;

clear Variable_TEMP ind ind_nnan ind_nan



% let's put our treated copernicus variable in NEMO space.

Variable_interp=interp3(xin,yin,zin,Variable_in,xout,yout,z);

clear Variable_in xin yin zin

for i = 1:length(nbidta)
    
z_obc(i,1,:) = squeeze(z(nbidta(i),nbjdta(i),:));
Variable_obc(i,1,:) = squeeze( Variable_interp(nbidta(i),nbjdta(i),:)); 
    
end


% ncid=netcdf.open(fname,'WRITE');
% varid = netcdf.inqVarID(ncid,'vosaline');
% 
% netcdf.putVar(ncid,varid,Variable_interp)



end


