function [mat_new] = smooth2(mat_old,stencilx,stencily)


%stencil = 2;

% check matrix in each direction

% mat(x,y)

%mat_new=nan(size(mat_old,1),size(mat_old,2));

mat_new = mat_old;

for i=1:size(mat_old,1)
    for j=1:size(mat_old,2)
        
        if isnan(mat_old(i,j))
            
            type1=(i-1);
            type2=abs(i-size(mat_old,1));
            type3=(j-1);
            type4=abs(j-size(mat_old,2));
            
            
            %adj_stencil=min([stencil type1 type2 type3 type4]);
            
            
            
            
            
            x_min=(i-min([stencilx type1]));
            x_max=(i+min([stencilx type2]));
            y_min=(j-min([stencily type3]));
            y_max=(j+min([stencily type4]));
            
            sub_mat = mat_old(x_min:x_max,y_min:y_max);
            
            
            mat_new(i,j) = nanmean(sub_mat(:));
            
            %end
            
            %         if isnan(mat_old(i,j))
            %             mat_new(i,j)=NaN;
            %         end
            
            
        end
    end
end


end

