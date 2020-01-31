#Install NRCT
export WORK=/work/jenjar
export PYTHON=$WORK/nrct/Python
cd $WORK

module load anaconda/2.1.0  # Want python2

conda create --name nrct_env scipy=0.16.0 numpy=1.9.2 matplotlib=1.4.3 basemap=1.0.7 netcdf4=1.1.9 libgfortran=1.0.0

source activate nrct_env

conda install -c https://conda.anaconda.org/conda-forge seawater=3.3.4 # Note had to add https path
conda install -c https://conda.anaconda.org/srikanthnagella thredds_crawler
conda install -c https://conda.anaconda.org/srikanthnagella pyjnius

#find and set the java path
export LD_LIBRARY_PATH=/usr/lib/jvm/jre-1.7.0-openjdk-1.7.0.241-2.6.20.0.el7_7.x86_64/lib/amd64/server:$LD_LIBRARY_PATH
unset SSH_ASKPASS 

# obtain the tool from git repository
git clone https://bitbucket.org/jdha/nrct.git

#load the correct branch
cd $WORK/nrct
#git checkout Generalise-tide-input
git checkout ORCA0083

cd $PYTHON

python setup.py build
export PYTHONPATH=/login/$USER/.conda/envs/nrct_env/lib/python2.7/site-packages/:$PYTHONPATH
python setup.py install --prefix ~/.conda/envs/nrct_env

