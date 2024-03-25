#!/bin/bash
#SBATCH --job-name=SANH
#SBATCH --time=00:06:00
#SBATCH --cpus-per-task=1
#SBATCH --account=n01-SANH
#SBATCH --partition=standard
#SBATCH --qos=standard

#SBATCH --nodes=41

# Setup the job environment (this module needs to be loaded before any other modules)
module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1


# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically 
#   using threading.
export OMP_NUM_THREADS=1
export UCX_IB_REG_METHODS=direct
ulimit -s unlimited
ulimit -c unlimited

SHARED_ARGS="--distribution=block:block --hint=nomultithread"

# Launch the parallel job
#   Using 512 MPI processes and 128 MPI processes per node
#   srun picks up the distribution from the sbatch options
srun --het-group=0 --nodes=4 --tasks-per-node=2 ${SHARED_ARGS} ./xios_server.exe : \
     --het-group=1 --nodes=37 --tasks-per-node=126 ${SHARED_ARGS} ./nemo.exe

