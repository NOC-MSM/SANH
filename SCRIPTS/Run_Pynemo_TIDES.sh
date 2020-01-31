#----------SCRIPT FOR GENERATING TIDES WITH PYNEMO--------------


#set up paths
export WORK=/work/jenjar
export PYTHON=$WORK/nrct/Python
cd $WORK/nrct


#load modules (livljobs7)
module load anaconda/2.1.0  # Want python2
source activate nrct_env2
export LD_LIBRARY_PATH=/usr/lib/jvm/jre-1.7.0-openjdk-1.7.0.241-2.6.20.0.el7_7.x86_64/lib/amd64/server:$LD_LIBRARY_PATH

#switch branch
git checkout Generalise-tide-input

#build PyNEMO
cd $PYTHON
python setup.py build
export PYTHONPATH=/login/$USER/.conda/envs/nrct_env2/lib/python2.7/site-packages/:$PYTHONPATH
python setup.py install --prefix ~/.conda/envs/nrct_env2

cd /projectsa/accord/SANH_jenjar/CMEMS_SANH 


#Run script
echo "Running PyNEMO Tides"

pynemo -s namelist_FES14.bdy > Tide_pynemo.txt 2>&1

source deactivate
