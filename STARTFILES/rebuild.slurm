#!/bin/bash
#SBATCH --job-name=rebuild
#SBATCH --time=00:20:00
#SBATCH --ntasks=1
#SBATCH --account=n01-SANH
#SBATCH --partition=serial
#SBATCH --qos=serial

#SBATCH --mem=84G

# Setup the job environment (this module needs to be loaded before any other modules)
module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1


# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically 
#   using threading.
export OMP_NUM_THREADS=1

# Launch the parallel job
#   Using 512 MPI processes and 128 MPI processes per node
#   srun picks up the distribution from the sbatch options

/work/n01/n01/jenjar93/CLASS_WORKSHOP/CLASS_WORKSHOP_DEMO/NEMO_4.0.4/tools/REBUILD_NEMO/rebuild_nemo -t 1 ./output.abort 4662


