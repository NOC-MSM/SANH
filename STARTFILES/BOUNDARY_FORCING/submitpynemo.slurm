#!/bin/bash
#SBATCH --job-name=pynemo
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --account=n01-SANH
#SBATCH --partition=serial
#SBATCH --qos=serial

source ~/.bashrc
conda activate pynemo
/work/n01/n01/jenjar93/TEST_SANH/BOUNDARY_FORCING/
pynemo -s namelist.bdy
