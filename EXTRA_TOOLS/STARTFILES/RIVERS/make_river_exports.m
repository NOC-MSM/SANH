%Create unit corrected tables
clear all; clc;

addpath('C:\Users\jenjar\Desktop\GlobalNEWS2modelcode\output\SANH');
year = [1980];

secs = 365*24*3600; %no. of seconds in a year


for n = 1:length(year)
    T = readtable(['c00_NEWS2Output_', num2str(year(n)), '.csv']);
   
    T2(:,1) = T(:,1);
    T2(:,2:10) = T(:,11:19);
    T2 = table2array(T2);
    x = T2(:,2:10).*1e6; % converting Mg/yr into g/yr;
    x = x./secs; %no. of seconds in a year to create g/s.
    river_exports(:,2:10) = x;
    filename = (['river_exports_' num2str(year(n)) '.mat'])
    save(filename,'river_exports');
   clear T2 T
end 


