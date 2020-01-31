clear all; clc

year = [1980:2005]; % CHANGE
load Qact_1980_2005 % CHANGE

for irun = 1 %:length(year)

DOMNAM='SANH';
%environment
num_land_mass= 4 %35;
addpath(genpath('/login/jdha/matlab/new_matlab/utilities/ann_mwrapper'))

%  bathy_fname=('bathy_meter_ORCA12.nc'); % SEAsia bathy
%  coords_fname=('coordinates_ORCA12.nc'); % SEAsia coordinates
bathy_fname=('bathy_meter.nc'); % SANH bathy
coords_fname=('coordinates.nc'); % SANH coordinates
mouth_fname=('rivermouths.txt');
rivers_path='/work/jholt/Git/DEV_jholt/Global_Rivers/GlobalNEWS2ModeledExports_RH2000-version1.0.1/';
month_rivs_path='/work/jholt/Git/DEV_jholt/Global_Rivers/news_monthly_output/discharge/';
 

%%
% Grid information
Re=6367456.0*pi/180;
lon = double(ncread(coords_fname,'nav_lon'));
lat = double(ncread(coords_fname,'nav_lat'));
e1t = ncread(coords_fname,'e1t');
e2t = ncread(coords_fname,'e2t');
nx=size(lon,1);
ny=size(lon,2);
D = ncread(bathy_fname,'Bathymetry');
dr=mean([e1t(:) ; e2t(:)]);
dx=mean(e1t(:))./(Re.*cos(mean(lon(:)).*180/pi));
dy=mean(e2t(:))./Re;
%limit mask to big land masses

NN=numberarea(D,0);
DD=D;
DD(NN>num_land_mass)=10;

%Masks
mask_coast = DD==0 ;
mask_shelf = D>0  ;

mask_coast = [mask_coast(1,:); mask_coast; mask_coast(end,:)] ;
mask_coast = [mask_coast(:,1), mask_coast, mask_coast(:,end)] ;

mask_coast = mask_coast(1:end-2,2:end-1) + mask_coast(3:end,2:end-1)      ...
          + mask_coast(2:end-1,1:end-2) + mask_coast(2:end-1,3:end) ;
mask = (mask_coast>0 & +mask_shelf==1) ;

% No rivers on boundaries
mask(1,:)=0; mask(end,:)=0;mask(:,1)=0;mask(:,end)=0;


lon_mask=lon(mask);
lat_mask=lat(mask);
[Imask Jmask]=find(mask);

%%
%catchments in the domaims
clear name_STN lon_rr lat_rr
disp('Named Basins in Domains. Might want to include these in: ')
disp(mouth_fname)
fid=fopen([rivers_path 'STN-30p-Names.csv']);
rn=fgets(fid);
ic=0
 while rn ~= -1
cc=strfind(rn,',');
id=str2num(rn(1:cc(1)-1));
name=rn(cc(1)+1:cc(2)-1);
lon_r=str2num(rn(cc(2)+1:cc(3)-1));
lat_r=str2num(rn(cc(3)+1:end));
s_const = 20 ;% search radius in grid cells 

    [DX,I] = min(abs(lon_mask(:)-lon_r)); DX=DX.*Re*cos(lat_r*pi/180) ;
    [DY,J] = min(abs(lat_mask(:)-lat_r)); DY=DY.*Re ;
  iblank=0;
 try
 if  strcmp(name(1:5),'GHAAS')
 iblank=1;   
 end
 end
 if abs(DX)<= s_const*dr   & abs(DY)<= s_const*dr & ~iblank;
 
disp([rn])
    
 end
ic=ic+1;
lon_rr(ic)=lon_r;
lat_rr(ic)=lat_r;
name_STN{ic}=name;
rn=fgets(fid);
end


%Make river forcing from grided catchment data and a list of river mouths

%% read list of known river mouth e.g. from google maps STN-30p
nriv=0;
try
fid=fopen(mouth_fname);
clear lon_riv lat_riv STN_riv
STNid=0;
rn=fgets(fid);

%while(~isempty(deblank(rn)));
 while rn ~= -1
rr=str2num(rn);
if isempty(rr);
 % its a name
 disp([rn])   
 aa=strfind(rn,':');
 if ~isempty(aa)
 STNid=str2num(rn(aa+1:end));
 disp(STNid)
 else
 STNid=0
 end
 
else
 nriv=nriv+1;
 disp(rr)
 lon_riv(nriv)=rr(1);
 lat_riv(nriv)=rr(2);
 STN_riv(nriv)=STNid;
 try
  frac_riv(nriv)=rr(3);
 catch
     frac_riv(nriv)=1.0;
 end
  
end
rn=fgets(fid);
 end
end

%%
mask_tmp=double(mask);
mask_tmp(D==0)=NaN; 
%% find grid cells of identified river mouths
clear I_riv J_riv;

for iriv=1:nriv;
r=((lon_mask-lon_riv(iriv))*cos(lat_riv(iriv)*pi/180)).^2+(lat_mask-lat_riv(iriv)).^2;
[mr ir]=(min(r));
I_riv(iriv)=Imask(ir);
J_riv(iriv)=Jmask(ir);
end

%%
new_file=1; %iterate
clear river_data
if new_file
    
%% GLOBAL NEWS 2 DATA ------------------------------------------------------------------------

%load data
river_data = load([rivers_path    'GlobalNEWS2_RH2000Dataset-version1.0.csv']) ;  
river_mnthfrac = load([month_rivs_path    'Discharge_AM2000.out']) ; 
load(['river_exports_',num2str(year(irun)),'.mat']);  % Unit corrections have already been done (Mg/yr --> g/s)


%%scale data (for rivers):
mnthfrac=river_mnthfrac (:,2:13)*12; % Multiply by 12 because it's not a cumulative value, but rather a mean 
sc=1000^3/365/24/3600;  
ibad = find(isnan(Qact));
Qact(ibad) = 0;
river_data(:,4)= Qact(:,irun).*sc;

%for nuts, will follow the same method as discharge
mnthfrac_nuts = river_mnthfrac(:,2:13)*12; %Multiply by 12 like above


%-----------------------------------------------------------------------------------------------
%%
STN30p=river_data(:,8);

% add a river index
    
%river_data(:,5 )= 1:length(river_data(:,1)) ;
else
%load in previous set
load river_mouths.mat
end
%%
% Find STN catchments in region
tmp_data = river_data;
clear II;
ic=0;
s_const = 20 ;% search radius in grid cells 
for i = 1:length(river_data(:,1));
    [DX,I] = min(abs(lon_mask(:)-river_data(i,1))); DX=DX.*Re*cos(river_data(i,2)*pi/180) ;
    [DY,J] = min(abs(lat_mask(:)-river_data(i,2))); DY=DY.*Re ;
 if abs(DX)<= s_const*dr   & abs(DY)<= s_const*dr;
     ic=ic+1;
     II(ic)=i;
 end
end
river_data=river_data(II,:);
mnthfrac=mnthfrac(II,:);
river_exports = river_exports(II,:); %% NUTS 
mnthfrac_nuts = mnthfrac_nuts(II,:);
for i=1:length(II)
name_STN1{i}=name_STN{II(i)};
end
name_STN=name_STN1;

%% i_r and j_r are grid indicies for each catchmemt, with 2nd index for multiple outputsfrom each catchment

i_r = ones(length(river_data(:,1)),10)*NaN ;
j_r = i_r ;
frac_r=i_r;

%match identified rivers
for iriv=1:nriv;
if STN_riv(iriv)~=0
    aa=find(STN_riv(iriv)==STN30p(II));
    if ~isempty(aa)
    ictch(iriv)=aa;
    else
    disp(['warning specified STN river not in list'])
    return
    end
else
%listed river mouths with non-specified names    
r=((river_data(:,1)-lon_riv(iriv))*cos(lat_riv(iriv)*pi/180)).^2+(river_data(:,2)-lat_riv(iriv)).^2;
[mr ictch(iriv)]=min(r);

disp(['match to : ' name_STN{ictch(iriv)}]);
end
ip=find(isnan(i_r(ictch(iriv),:)),1,'first');
i_r(ictch(iriv),ip)=I_riv(iriv);
j_r(ictch(iriv),ip)=J_riv(iriv);
frac_r(ictch(iriv),ip)=frac_riv(iriv);
end   
   hold off
  drawnow

%%
D(D==0)=NaN;

tmp1_data=river_data;    

all_ok=0;

clear Iriv Jriv rivflw
tmp_data=river_data;    
ncatch=length(river_data(:,1));

ic=0;
for i = 1:ncatch %loop over rivers
    if ~isfinite(i_r(i,1))
%nearest coastal point for each river
np=1;
%spread big rivers over more than one point
if river_data(i,4) > 1000;np=4;end
if river_data(i,4) > 800;np=3;end

  r=((river_data(i,1)-lon_mask)*cos(river_data(i,2)*pi/180)).^2+(river_data(i,2)-lat_mask).^2;
  r=sqrt(r)*Re;
   [mr icatch]=nanmin(r);
%%
% turn on coastline - SLOW!!
% map=0;
% 
% icc=0;
% if map
% llon=  lon-0.5*dx ;
% llat= lat-0.5*dy;
% 
% m_proj('Mercator','longitude',[min(llon(:)) max(llon(:))],'latitude',[min(llat(:)) max(llat(:))]);
% [X Y]=m_ll2xy(llon,llat);
% pcolor(X,Y,mask_tmp); shading flat
% hold on;
% m_plot(river_data(i,1),river_data(i,2),'xg','markersize',10)
% m_plot(lon_mask(icatch),lat_mask(icatch),'or','markersize',10);
% m_plot([river_data(i,1) lon_mask(icatch)],[river_data(i,2) lat_mask(icatch)],'g')
% hold off
% if ~icc; m_gshhs_h('save','coast.tmp');icc=1;end
% m_usercoast('coast.tmp')
% 
% else
% pcolor(lon-0.5*dx,lat-0.5*dy,mask_tmp); shading flat
% hold on;
% plot(river_data(i,1),river_data(i,2),'xg','markersize',10)
% plot(lon_mask(icatch),lat_mask(icatch),'or','markersize',10);
% plot([river_data(i,1) lon_mask(icatch)],[river_data(i,2) lat_mask(icatch)],'g')
% hold off
% end
%   drawnow 
  %% The below code chooses which rivers to keep and which to discard (user-defined)
 in_ok=0; % keep at 0 if already have a keep_indx.m file; else in_ok =1;
while in_ok 
    disp(mr)
  inp=input(['(k)eep (r)emove '],'s');
  
  if inp=='k';keep=1;in_ok=0;end
  if inp=='r';keep=0;in_ok=0;end
  keep_indx(i) = keep;
end
if in_ok==0
    load('keep_indx.mat') % user-defined rivers 
end 
keep = keep_indx(i);
if keep==1;
for j=1:np
   
   [mr icatch]=nanmin(r); 
ic =ic+1;    

    Iriv(ic)=Imask(icatch);
    Jriv(ic)=Jmask(icatch);
    disp(Iriv)
    rivflw(ic)=river_data(i,4)./np; % just spreading flow over several grid points
    DIN(ic) = river_exports(i,2)./np;
    DSi(ic) = river_exports(i,7)./np;
    DIP(ic) = river_exports(i,3)./np;
    DON(ic) = river_exports(i,4)./np;
    DOP(ic) = river_exports(i,5)./np;
    DOC(ic) = river_exports(i,6)./np;
    PN(ic) = river_exports(i,7)./np;
    PP(ic) = river_exports(i,8)./np;
    POC(ic) = river_exports(i,9)./np;
    
    mnthfracr(ic,:)=mnthfrac(i,:);
    mnthfracr_nuts(ic,:) = mnthfrac_nuts(i,:);
    r(icatch)=NaN;   
    riv_old(ic,1)=river_data(i,1);
    riv_old(ic,2)=river_data(i,2);
end
end


    else
     np=length(find(isfinite(i_r(i,:))));
     for ip=1:np
    ic=ic+1;
    Iriv(ic)=i_r(i,ip);
    Jriv(ic)=j_r(i,ip);
    rivflw(ic)=river_data(i,4).*frac_r(i,ip); 
    DIN(ic) = river_exports(i,2).*frac_r(i,ip)
    DSi(ic) = river_exports(i,7).*frac_r(i,ip);
    DIP(ic) = river_exports(i,3).*frac_r(i,ip);
    DON(ic) = river_exports(i,4).*frac_r(i,ip);
    DOP(ic) = river_exports(i,5).*frac_r(i,ip);
    DOC(ic) = river_exports(i,6).*frac_r(i,ip);
    PN(ic) = river_exports(i,7).*frac_r(i,ip);
    PP(ic) = river_exports(i,8).*frac_r(i,ip);
    POC(ic) = river_exports(i,9).*frac_r(i,ip);
    mnthfracr(ic,:)=mnthfrac(i,:);
    mnthfracr_nuts(ic,:) = mnthfrac_nuts(i,:);
    riv_old(ic,1)=river_data(i,1);
    riv_old(ic,2)=river_data(i,2);
    
     end
    end
end

% update data
i_r=Iriv;
j_r=Jriv;
    ncatch=length(i_r);
    clear river_data;
    for i=1:ncatch;
    river_data(i,1)=lon(i_r(i),j_r(i));
    river_data(i,2)=lat(i_r(i),j_r(i));
    river_data(i,4)=rivflw(i);
    river_data(i,5:16)=mnthfracr(i,:);
    test_DIN(i,4) = DIN(i);
    test_P(i,4) = DIP(i);
    test_Si(i,4) = DSi(i);
    test_DON(i,4) = DON(i);
    test_DOP(i,4) = DOP(i);
    test_DOC(i,4) = DOC(i);
    test_PN(i,4) = PN(i);
    test_PP(i,4) = PP(i);
    test_POC(i,4) = POC(i);
    test_DIN(i,5:16) = mnthfracr_nuts(i,:); %% NUTS EDITS!!
    test_Si(i,5:16) = mnthfracr_nuts(i,:);
    test_P(i,5:16) = mnthfracr_nuts(i,:);
    test_DON(i,5:16) = mnthfracr_nuts(i,:);
    test_DOP(i,5:16) = mnthfracr_nuts(i,:);
    test_DOC(i,5:16) = mnthfracr_nuts(i,:);
    test_PN(i,5:16) = mnthfracr_nuts(i,:);
    test_PP(i,5:16) = mnthfracr_nuts(i,:);
    test_POC(i,5:16) = mnthfracr_nuts(i,:);
    if mask(i_r(i),j_r(i))~=1;
    disp(['error']);    
    end
    end
%%

figure(2)
clf
      pcolor(lon-0.5*dx,lat-0.5*dy,mask_tmp); shading flat
        axis xy
        for i=1:ncatch
        hold on, plot(riv_old(i,1),riv_old(i,2),'co','markersize',10)

               plot(lon(i_r(i),j_r(i)),lat(i_r(i),j_r(i)),'*g','markersize',10)
               plot([riv_old(i,1) lon(i_r(i),j_r(i))],[riv_old(i,2) lat(i_r(i),j_r(i))],'g')
        end

     
       % set(gca,'Color',[0.7 0.7 0.7])
        xlabel('Longitude (^oE)');
        ylabel('Latitude (^oN)');%set(gca,'PlotBoxAspectRatio',[3 2 1],  ...
                                  %     'PlotBoxAspectRatioMode','manual') ; 
        set(gcf,'InvertHardCopy','off')
        set(gcf,'Color','w') 
        
        
        
        hold off
%%
 
if in_ok == 0
    make_riverforcing
end 
end 
