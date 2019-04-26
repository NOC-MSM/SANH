module load anaconda/2.1.0
module load nco/gcc/4.4.2.ncwa

echo " nco/gcc/4.4.2.ncwa ?"
echo " anaconda/2.1.0 ? "

echo "Have a quick check to see if the modules which preceed this message"
echo "are in the list given subsequent to this message"

module list


. cut_mask.sh



python Generate_NEMO_Forcing.py
python python_mask.py



mv ERA5_LSM.nc FORCING 
