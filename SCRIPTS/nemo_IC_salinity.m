clear all
clc
addpath('/projectsa/ETI/Tracer_work/Matlab_progs')

fname = 'initcd_vosaline.nc';
fname_data = 'Sal_16_0000.nc';
z_data = 'domain_cfg.nc';

Sin=ncread(fname_data,'so');
xin=double(ncread(fname_data,'longitude'));
yin=double(ncread(fname_data,'latitude'));
zin=double(ncread(fname_data,'depth'));
Sin=permute(Sin,[2 1 3]);

Sout=double(ncread(fname,'vosaline'));
xout=double(ncread(fname,'x'));
yout=double(ncread(fname,'y'));
dzout=ncread(z_data,'e3t_0');

xout=repmat(xout,1,1,size(Sout,3));
yout=repmat(yout,1,1,size(Sout,3));




z=zeros(size(Sout,1),size(Sout,2),size(Sout,3));

for i=1:size(Sout,3)
    
    
    if i==1
        z(:,:,i)=dzout(:,:,i);
    else
        z(:,:,i)=z(:,:,i-1)+dzout(:,:,i);
    end
    
    
    
end

zin(1)=0;
zin(end)=max(z(:))+1;


% 
% parfor i=1:size(Sin,3)
%     i
% Sin(:,:,i)=smooth2(Sin(:,:,i),100,100);
% 
% end




Sinterp=interp3(xin,yin,zin,Sin,xout,yout,z);





ncid=netcdf.open(fname,'WRITE');
varid = netcdf.inqVarID(ncid,'vosaline');

netcdf.putVar(ncid,varid,Sinterp)


