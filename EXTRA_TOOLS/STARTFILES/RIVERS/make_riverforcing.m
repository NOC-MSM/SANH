 rivfilename=(['rivers_y',num2str(year(irun)),'.nc']);
 check_delete(rivfilename);

%%
% single domain verison
rho0=1000;
nx=size(D,1);
ny=size(D,2);
mnth=1;
rorunoff=zeros(nx,ny,12);  % value of dummy variable
DINrunoff=zeros(nx,ny,12);
DISirunoff = zeros(nx,ny,12);
DIPrunoff = zeros(nx,ny,12);
DOPrunoff = zeros(nx,ny,12);
DOCrunoff = zeros(nx,ny,12);
DONrunoff = zeros(nx,ny,12);
PNrunoff = zeros(nx,ny,12);
PPrunoff = zeros(nx,ny,12);
POCrunoff = zeros(nx,ny,12);

% Added nuts, same method as for river discharge

 for i=1:length(i_r)
     if ~mnth
     rorunoff(i_r(i),j_r(i),:)=river_data(i,4)*rho0/(e1t(i_r(i),j_r(i)).*e2t(i_r(i),j_r(i))); % This is a unit conversion - density * gridded area
        DINrunoff(i_r(i),j_r(i),:)=test_DIN(i,4); % Don't need the conversion above for nuts, as did the unti conversion in spreadsheet
            DSirunoff(i_r(i),j_r(i),:)=test_Si(i,4);
                DIPrunoff(i_r(i),j_r(i),:)=test_P(i,4);
                 DONrunoff(i_r(i),j_r(i),:)=test_DON(i,4);
                   DOPrunoff(i_r(i),j_r(i),:)=test_DOP(i,4);
                     DOCrunoff(i_r(i),j_r(i),:)=test_DOC(i,4);
                      PNrunoff(i_r(i),j_r(i),:)=test_PN(i,4);
                       PPrunoff(i_r(i),j_r(i),:)=test_PP(i,4);
                         POCrunoff(i_r(i),j_r(i),:)=test_POC(i,4);
     else
     for im=1:12
          rorunoff(i_r(i),j_r(i),im)=river_data(i,4)*rho0/(e1t(i_r(i),j_r(i)).*e2t(i_r(i),j_r(i)))*river_data(i,4+im);
            DINrunoff(i_r(i),j_r(i),im)=test_DIN(i,4)*test_DIN(i,4+im); 
               DSirunoff(i_r(i),j_r(i),im)=test_Si(i,4)*test_Si(i,4+im);
                 DIPrunoff(i_r(i),j_r(i),im)=test_P(i,4)*test_P(i,4+im);
                  DONrunoff(i_r(i),j_r(i),im)=test_DON(i,4)*test_DON(i,4+im);
                   DOPrunoff(i_r(i),j_r(i),im)=test_DOP(i,4)*test_DOP(i,4+im);
                    DOCrunoff(i_r(i),j_r(i),im)=test_DOC(i,4)*test_DOC(i,4+im);
                     PNrunoff(i_r(i),j_r(i),im)=test_PN(i,4)*test_PN(i,4+im);
                      PPrunoff(i_r(i),j_r(i),im)=test_PP(i,4)*test_PP(i,4+im);
                       POCrunoff(i_r(i),j_r(i),im)=test_POC(i,4)*test_POC(i,4+im);
     end
     end
 end
 

%  %fixes
% if strcmp(DOMNAM,'BLZE12');
%  rr=rorunoff(156,61,1);
% rorunoff(156,61,:)=rr/3;
% rorunoff(157,61,:)=rr/3;
% rorunoff(158,61,:)=rr/3;
% 
% rr=rorunoff(111,22,:);
% rorunoff(111,22,:)=rr/3;
% rorunoff(112,22,:)=rr/3;
% rorunoff(113,22,:)=rr/3;
% end
% if strcmp(DOMNAM,'HBOB34_1k');
%    rr=rorunoff(454,174,1);
% ii=[454 455 456 451 452 453 448 449 450]; 
% jj=[174 174 174 175 175 175 176 176 176];
% nr=length(ii);
% for i=1:nr;
% rorunoff(ii(i),jj(i),:)=rr/nr;
% end
% end

 %%
 
output=rivfilename;
nccreate(output,'time_counter','Dimensions',{'time_counter',Inf},'Format','netcdf4_classic');
nccreate(output,'lat','Dimensions',{'lat',ny},'Format','netcdf4_classic');
nccreate(output,'lon','Dimensions',{'lon',nx},'Format','netcdf4_classic');
nccreate(output,'rorunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
nccreate(output,'DINrunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
nccreate(output,'DSirunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
nccreate(output,'DIPrunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
nccreate(output,'DONrunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
nccreate(output,'DOPrunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
nccreate(output,'DOCrunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
nccreate(output,'PNrunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
nccreate(output,'PPrunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
nccreate(output,'POCrunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');

ncwrite(output,'lon',(1:nx));
ncwrite(output,'lat',(1:ny));
ncwrite(output,'rorunoff',rorunoff);
ncwrite(output,'DINrunoff',DINrunoff);
ncwrite(output,'DSirunoff',DSirunoff);
ncwrite(output,'DIPrunoff',DIPrunoff);
ncwrite(output,'DONrunoff',DONrunoff);
ncwrite(output,'DOPrunoff',DOPrunoff);
ncwrite(output,'DOCrunoff',DOCrunoff);
ncwrite(output,'PNrunoff',PNrunoff);
ncwrite(output,'PPrunoff',PPrunoff);
ncwrite(output,'POCrunoff',POCrunoff);

ncwrite(output,'time_counter',(1:12));