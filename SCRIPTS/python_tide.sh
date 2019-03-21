cd $WORK/nrct/Python

git checkout Generalise-tide-input

python setup.py build
export PYTHONPATH=~/.conda/envs/nrct_env/lib/python2.7/site-packages/:$PYTHONPATH

python setup.py install --prefix ~/.conda/envs/nrct_
