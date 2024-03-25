#run pynemo
export CONFIG=SANH_jenjar
export WORK=/work/jenjar
export OUTPUT=/projectsa/accord/SANH_jenjar/CMEMS_SANH/OUTPUT
export PYTHON=$WORK/nrct/Python

#load modules (livljobs7)


#setup environment
module load anaconda 
conda activate nrct_env_py3
export LD_LIBRARY_PATH=/usr/lib/jvm/jre-1.7.0-openjdk-1.7.0.261-2.6.22.2.el7_8.x86_64/lib/amd64/server:$LD_LIBRARY_PATH



#switch branch (if necessary)
cd $WORK/nrct
git checkout ORCA0083

#build PyNEMO
cd $PYTHON

python setup.py build
export PYTHONPATH=/work/$USER/jenjar-conda/nrct_env_py3/lib/python2.7/site-packages:$PYTHONPATH
python setup.py install --prefix /work/$USER/jenjar-conda/nrct_env_py3
 


#create directory for storage of year
cd OUTPUT 
cd ..

echo "Running PyNEMO"

pynemo -s namelist_2005.bdy > Test_pynemo.txt 2>&1

conda deactivate
