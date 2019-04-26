clear all
clc


fname = 'initcd_vosaline.nc';
fname_data = 'Sal_16_0000.nc';
z_data = 'domain_cfg.nc';

Sin=ncread(fname_data,'so');
xin=double(ncread(fname_data,'longitude'));
yin=double(ncread(fname_data,'latitude'));
zin=double(ncread(fname_data,'depth'));
Sin=permute(Sin,[2 1 3]);


xout=double(ncread(z_data,'nav_lon'));
yout=double(ncread(z_data,'nav_lat'));
dzout=ncread(z_data,'e3t_0');

xout=repmat(xout,1,1,size(dzout,3));
yout=repmat(yout,1,1,size(dzout,3));




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




[Xin,Yin,Zin]=meshgrid(xin,yin,zin);



Xlr=Xin(~isnan(Sin));
Ylr=Yin(~isnan(Sin));
Zlr=Zin(~isnan(Sin));
Slr=Sin(~isnan(Sin));



Sin=griddata(Xlr,Ylr,Zlr,Slr,Xin,Yin,Zin);


ind_nnan=~isnan(Sin(:));
ind_nan = isnan(Sin(:));

Xlnnan=Xin(ind_nnan);
Ylnnan=Yin(ind_nnan);
Zlnnan=Zin(ind_nnan);
coordnnan=[Xlnnan Ylnnan Zlnnan];

Xlnan=Xin(ind_nan);
Ylnan=Yin(ind_nan);
Zlnan=Zin(ind_nan);
coordnan=[Xlnan Ylnan Zlnan];

ind=knnsearch(coordnnan,coordnan);

S_TEMP=Sin(ind_nnan);
S_TEMP=S_TEMP(ind);


Sin(isnan(Sin))=S_TEMP;








Sinterp=interp3(xin,yin,zin,Sin,xout,yout,z);





ncid=netcdf.open(fname,'WRITE');
varid = netcdf.inqVarID(ncid,'vosaline');

netcdf.putVar(ncid,varid,Sinterp)


