#run pynemo
export CONFIG=SANH_jenjar
export WORK=/work/jenjar
export OUTPUT=/projectsa/accord/SANH_jenjar/CMEMS_SANH/OUTPUT
export PYTHON=$WORK/nrct/Python

#load modules (livljobs7)
module load anaconda/2.1.0  # Want python2

#setup environment
source activate nrct_env2
export LD_LIBRARY_PATH=/usr/lib/jvm/jre-1.7.0-openjdk-1.7.0.241-2.6.20.0.el7_7.x86_64/lib/amd64/server:$LD_LIBRARY_PATH


#switch branch (if necessary)
cd $WORK/nrct
git checkout ORCA0083

cd $PYTHON
python setup.py build
export PYTHONPATH=/login/$USER/.conda/envs/nrct_env2/lib/python2.7/site-packages/:$PYTHONPATH
python setup.py install --prefix ~/.conda/envs/nrct_env2 


#create directory for storage of year
cd $OUTPUT
mkdir 2001 
cd ..

echo "Running PyNEMO"

pynemo -s namelist_2001.bdy > Test_pynemo.txt 2>&1

source deactivate
