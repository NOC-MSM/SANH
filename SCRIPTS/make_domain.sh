#################################################################
#	***	CREATE THE DOMAIN CONFIGURATION FILE 	***
#################################################################


#----------------------------------------------------------------
# 1. CREATE THE COORDINATES 
# ---------------------------------------------------------------

# For the purposes of this demo, we will use the GLOBAL_ORCA_R12 coordinates.

# ATTENTION! Open a fresh terminal to avoid previous module conflicts.


cd $WDIR/DOMAIN
cp $EXTRA/DOMAIN/namelist.input ./

# Edit the namelist.input file for your chosen region:
# &nesting
#    imin = XXXX
#    imax = XXXX
#    jmin = XXXX
#    jmax = XXXX
#    rho  = 1
#    rhot = 1
#    bathy_update = false


# Load modules and copy the namelist.input file into the NEMO TOOLS directory: 
module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1

cd $TDIR/NESTING
cp $DOMAIN/namelist.input $TDIR/NESTING/ 


# Download the parent coordinate file:
wget http://gws-access.jasmin.ac.uk/public/nemo/runs/ORCA0083-N06/domain/coordinates.nc -O ./coordinates_ORCA_R12.nc


#Run the AGRIF TOOL to generate the coordinates: 
./agrif_create_coordinates.exe
cp 1_coordinates_ORCA_R12.nc $DOMAIN/coordinates.nc
cd $SCRIPTS


#-----------------------------------------------------------
# 2. Create the Bathymetry 
# ----------------------------------------------------------

# The bathymetry is created using the NEMO tools, submitted as a serial job (job_create_bathy.slurm)

# In a new terminal window, copy over the required files: 
cp namelist_reshape_billin_eORCA12 $DOMAIN/


# Generate the bathymetry file:
module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1

$TDIR/WEIGHTS/scripgrid.exe namelist_reshape_bilin_eORCA12
$TDIR/WEIGHTS/scrip.exe namelist_reshape_bilin_eORCA12
$TDIR/WEIGHTS/scripinterp.exe namelist_reshape_bilin_eORCA12


# To generate the file, submit the job script: 
sbatch job_create_bathy.slurm 


#-----------------------------------------------------------
# 3. Create the domain configuration file 
# ----------------------------------------------------------

# Copy over the namelist_cfg into the DOMAINcfg directory
cp $EXTRA/DOMAIN/namelist_cfg $TDIR/DOMAINcfg/namelist_cfg 

# In namelist_cfg, edit the x and y (i,j) coordinate bounds to match your bathymetry file

# Link your coordinates and bathymetry file to the TOOLS domain directory: 
ln -s $DOMAIN/coordinates.nc $TDIR/DOMAINcfg/
ln -s $DOMAIN/bathy_meter.nc $TDIR/DOMAINcfg/

# Copy over an updated file that incorporates z-s hybrid namdom: 
cp $EXTRA/DOMAIN/domzgr_jelt_changes.f90 $TDIR/DOMAIncfg/src/domzgz.f90 

# The domain creation is submitted as a job: 
cd $TDIR/DOMAINcfg
cp $EXTRA/DOMAIN/job_create_domain.slurm $TDIR/DOMAINcfg/job_create.sh 


# Copy the created domain_cfg.nc file into your DOMAIN directory:
cp $TDIR/DOMAINcfg/domain_cfg.nc $DOMAIN/domain_cfg.nc 


############################################################
#		    *** FINISHED!! ***		   
############################################################		    
















