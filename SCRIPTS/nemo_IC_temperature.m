clear all
clc

fname = 'initcd_votemper.nc';
fname_data = 'Temp_16_0000.nc';
z_data = 'domain_cfg.nc';

Tin=ncread(fname_data,'thetao');
xin=double(ncread(fname_data,'longitude'));
yin=double(ncread(fname_data,'latitude'));
zin=double(ncread(fname_data,'depth'));
Tin=permute(Tin,[2 1 3]);

Tout=double(ncread(fname,'votemper'));
xout=double(ncread(fname,'x'));
yout=double(ncread(fname,'y'));
dzout=ncread(z_data,'e3t_0');

xout=repmat(xout,1,1,size(Tout,3));
yout=repmat(yout,1,1,size(Tout,3));




z=zeros(size(Tout,1),size(Tout,2),size(Tout,3));

for i=1:size(Tout,3)
    
    
    if i==1
        z(:,:,i)=dzout(:,:,i);
    else
        z(:,:,i)=z(:,:,i-1)+dzout(:,:,i);
    end
    
    
    
end

zin(1)=0;
zin(end)=max(z(:))+1;



% parfor i=1:size(Tin,3)
%     i
% Tin(:,:,i)=smooth2(Tin(:,:,i),100,100);
% 
% end



Tinterp=interp3(xin,yin,zin,Tin,xout,yout,z);





ncid=netcdf.open(fname,'WRITE');
varid = netcdf.inqVarID(ncid,'votemper');

netcdf.putVar(ncid,varid,Tinterp)


