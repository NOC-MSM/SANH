module unload anaconda
module load anaconda/2.2.0-python2

rm -rf ~/.conda
yes | conda create --name nrct_env scipy=0.17.0 numpy matplotlib basemap netcdf4 libgfortran=1.0.0
source activate nrct_env
yes | conda install -c https://conda.anaconda.org/conda-forge seawater=3.3.4 # Note had to add https path
yes | conda install -c https://conda.anaconda.org/srikanthnagella thredds_crawler
yes | conda install -c https://conda.anaconda.org/srikanthnagella pyjnius

#module load java
LD_LIBRARY_PATH=/opt/java/jdk1.8.0_51/jre/lib/amd64/server/:$LD_LIBRARY_PATH



cd $WORK/nrct/Python

python setup.py build
export PYTHONPATH=~/.conda/envs/nrct_env/lib/python2.7/site-packages/:$PYTHONPATH

python setup.py install --prefix ~/.conda/envs/nrct_env

#cd $TIDE
#pynemo -s namelist.bdy



