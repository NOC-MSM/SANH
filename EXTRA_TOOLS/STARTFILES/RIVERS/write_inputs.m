%% Automate the Excel file names:

%%load excel data 

load('tableA'); %DSimodelinputs
load('tableB'); %c00dischfqremreservretng 
load('tableC'); %c00hydropntsrcotherng

%%load the hydro data

load hydro_1980
year = [1980]

%% Fill in the data

ibad = find(isnan(x.p_year));
x.p_year(ibad) = 0;
ibad = find(isnan(x.Qact));
x.Qact(ibad) = 0;
ibad = find(isnan(x.Qnat));
x.Qnat(ibad) = 0;
ibad = find(isnan(x.Rnat));
x.Rnat(ibad) = 0;
p_year = x.p_year./365;

for i = 1:length(year)
    
A(:,2) = num2cell(p_year(:,i));
B(:,3) = num2cell(x.Qact(:,i));
B(:,4) = num2cell(x.Qnat(:,i));
C(:,2) = num2cell(x.Rnat(:,i));
C(:,5) = num2cell(x.p_year(:,i));

writetable(A,['DSi_model_inputs_' num2str(year(i)) '.csv']);
writetable(B,['c00_disch_fqrem_reservret_ng_' num2str(year(i)) '.csv']);
writetable(C,['c00_hydro_pntsrc_other_ng_' num2str(year(i)) '.csv']);
end 

disp('INPUTS FINISHED... Now RUN MODEL per year');
