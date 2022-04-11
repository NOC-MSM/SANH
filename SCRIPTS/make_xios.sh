#Compile XIOS on Archer2
cd $WDIR
#####################################
#download install xios
####################################
#load modules

module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.0.7
module load cray-netcdf-hdf5parallel/4.7.4.7

#download xios
svn checkout http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/branchs/xios-2.5 $XIOS_DIR
cd $XIOS_DIR

#copy the arch
cp /work/n01/shared/nemo/xios-2.5/arch/arch-X86_ARCHER2-Cray.* arch/.

#compile xios
./make_xios --prod --arch X86_ARCHER2-Cray --netcdf_lib netcdf4_par --full --job 4

# First time compile will fail 
# got to $XIOS_DIR/tools/FCM/lib/Fcm/Config.pm and change
# FC_MODSEARCH => '',             # FC flag, specify "module" path
#to
#FC_MODSEARCH => '-J',           # FC flag, specify "module" path  
sed -i "s/FC_MODSEARCH => ''/FC_MODSEARCH => '-J'/g" tools/FCM/lib/Fcm/Config.pm

#recompile xios
./make_xios --prod --arch X86_ARCHER2-Cray --netcdf_lib netcdf4_par --full --job 4

#######################################
cd $WORK

