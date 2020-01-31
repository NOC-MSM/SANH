#!/bin/bash
#PBS -N init_T
#PBS -l select=serial=true:ncpus=1
#PBS -l walltime=06:00:00
#PBS -o init_T.log
#PBS -e init_T.err
#PBS -A n01-ACCORD
###################################################

module swap PrgEnv-cray PrgEnv-intel
module load cray-hdf5-parallel
module load cray-netcdf-hdf5parallel

cd /work/n01/n01/jenjar93/sosie
make clean
make
make install

#set up paths
cd /work/n01/n01/jenjar93/SANH_01/INITIAL_CONDITIONS/

/home/n01/n01/jenjar93/local/bin/sosie3.x -f initcd_votemper.namelist

# qsub -q serial <filename>
###################################################

