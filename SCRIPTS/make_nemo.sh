#Compile NEMO on Archer2
cd $WDIR 
#################################################################
#first get/download NEMO 
#################################################################
#get nemo (only use firts time you install. Comment out before compiling once nemo is installed)
svn co http://forge.ipsl.jussieu.fr/nemo/svn/NEMO/branches/UKMO/NEMO_4.0.4_mirror NEMO_4.0.4 

#######################################################################
#load modules
module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.0.7
module load cray-netcdf-hdf5parallel/4.7.4.7

#compile nemo
#################################################################
# get arch 
#ATTENTION modify the following file to have the correct path for xios
cp /work/n01/shared/nemo/ARCH/arch-X86_ARCHER2-Cray.fcm $NEMO/arch/arch-X86_ARCHER2-Cray.fcm

cd $NEMO
# go to ext/FCM/lib/Fcm/Config.pm and change
# FC_MODSEARCH => '',             # FC flag, specify "module" path
#to
#FC_MODSEARCH => '-J',           # FC flag, specify "module" path
sed -i "s/FC_MODSEARCH => ''/FC_MODSEARCH => '-J'/g" ext/FCM/lib/Fcm/Config.pm

cd $NEMO
#make configuration first
./makenemo -n $CONFIG -r AMM12  -m X86_ARCHER2-Cray -j 16

#make configuration with updates included 
cd $NEMO
./makenemo -r $CONFIG -m X86_ARCHER2-Cray -j 16 clean
./makenemo -r $CONFIG -m X86_ARCHER2-Cray -j 16
#################################################################
cd $WDIR
