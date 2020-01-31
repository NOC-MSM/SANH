%% Creating river exports:

%Mg/yr into mmol/s --> right unit conversions? Or do we need g/s? 

%not needed; units are in g/s
%molecular weights; 
% N = 0.07139440416606;
% P = 0.03560556158872;
% S = 0.03228539149637;
%% USE RIVER LOAD NOT YIELD!!!!
%river_exports = test_outputs; %RH2000nuts;

secs = 365*24*3600; %no. of seconds in a year

% All nuts;
x = river_exports(:,2:10).*1e6; % converting Mg/yr into g/yr;
x = x./secs; %no. of seconds in a year to create g/s.
river_exports(:,2:10) = x;




%% Nitrogen 
DIN = river_exports(:,2).*1e6; % converting Mg/yr into g/yr;
% DIN = DIN.*N; % converting into moles/yr
% DIN = DIN.*1e3; %converting into mmol/yr
DIN = DIN./ secs; %no. of seconds in a year to create mmol/s.

river_exports(:,2) = DIN;
%% Silicon

DSi = river_exports(:,7).*1e6; % converting Mg/yr into g/yr;
% DSi = DSi.*S; % converting into moles/yr
% DSi = DSi.*1e3; %converting into mmol/yr
DSi = DSi./ secs; %no. of seconds in a year to create mmol/s.

river_exports(:,7) = DSi;

%% Phosphorous

DIP = river_exports(:,3).*1e6; % converting Mg/yr into g/yr;
% DIP = DIP.*P; % converting into moles/yr
% DIP = DIP.*1e3; %converting into mmol/yr
DIP = DIP./ secs; %no. of seconds in a year to create mmol/s.

river_exports(:,3) = DIP;




