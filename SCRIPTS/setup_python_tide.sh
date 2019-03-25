module unload anaconda/2.2.0-python2

module load anaconda

git clone https://ashbre@bitbucket.org/jdha/nrct.git $WORK/nrct

module unload anaconda

module load anaconda/2.2.0-python2


yes | conda create --name nrct_tide scipy=0.17.0 numpy matplotlib basemap netcdf4 libgfortran=1.0.0
source activate nrct_tide
yes | conda install -c https://conda.anaconda.org/conda-forge seawater=3.3.4 # Note had to add https path
yes | conda install -c https://conda.anaconda.org/srikanthnagella thredds_crawler
yes | conda install -c https://conda.anaconda.org/srikanthnagella pyjnius

#module load java
LD_LIBRARY_PATH=/opt/java/jdk1.8.0_51/jre/lib/amd64/server/:$LD_LIBRARY_PATH

source deactivate nrct_tide


cd $WORK/nrct/Python

git checkout Generalise-tide-input

python setup.py build
export PYTHONPATH=~/.conda/envs/nrct_tide/lib/python2.7/site-packages/:$PYTHONPATH
#export PYTHONPATH=/work/n01/n01/jelt/jelt-conda/envs/nrct_tide/lib/python2.7/site-packages/:$PYTHONPATH

python setup.py install --prefix ~/.conda/envs/nrct_tide
#python setup.py install --prefix /work/n01/n01/jelt/jelt-conda/envs/nrct_tide

cd $WDIR
