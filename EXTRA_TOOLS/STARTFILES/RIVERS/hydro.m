function [Run1,Qact1,Qnat1] = hydro(p_yearly)


load fractions;

Qact1 = p_yearly./Qact(1:length(p_yearly));
Qnat1 = p_yearly./Qnat(1:length(p_yearly));
Run1 = p_yearly./Rnat(1:length(p_yearly));

clear Qact Qnat Rnat
end 