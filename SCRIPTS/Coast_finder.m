function [lon_coast,lat_coast,coastal] = Coast_finder(bathy_fname)

%bathy_fname = '../DATA/bathy_meter.nc';

B=ncread(bathy_fname,'Bathymetry');
lon=ncread(bathy_fname,'nav_lon');
lat=ncread(bathy_fname,'nav_lat');

% build a land sea mask.

B(isnan(B))=0;
B(B>0)=1;
B=-B+1;

% we define a costal point as a wet point that has at least one dry point
% around it

coastal = zeros(size(B,1),size(B,2)); 

for i = 1:size(B,1)
    for j = 1:size(B,2)
        
        
        
        if B(i,j)==0
            
            
            adj_points(1:4)=0;
          
            if i<size(B,1)
            adj_points(1)=B(i+1,j);
            end
            
            if i>1
            adj_points(2)=B(i-1,j);
            end
            
            if j<size(B,2)
            adj_points(3)=B(i,j+1);
            end
            
            if j>1
            adj_points(4)=B(i,j-1);
            end
            
            
            
            if sum(adj_points)>0
                coastal(i,j)=1;
            end
            
            
            
            
        end
        
        
        
        
        
        
    end
end

coastal=logical(coastal);
     
lon_coast=lon(coastal);
lat_coast=lat(coastal);


end
        