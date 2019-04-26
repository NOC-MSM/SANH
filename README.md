# NEMO_cfgs
NEMO BoBEAS configuration

Each configuration directory should be laid out in the following manner, to
facilitate configuration archival and sharing:

<pre>
BoBEAS
|____NAMELISTS_AND_FORTRAN_FILES
| |___INITIAL_CONDITION
| | |____initcd_vosaline.namelist
| | |____initcd_votemper.namelist
| | |____namelist_reshape_bilin_initcd_vosaline
| | |____namelist_reshape_bilin_initcd_votemper
| | |____sosie.x
| |
| |___RUN_DIRECTORY
| | |____namelist_cfg
| | |____namelist_ref
| |
| |___TIDES
| | |____inputs_dst.ncml
| | |____inputs_src.ncml
| | |____namelist.bdy
| | |____run_script.pbs
| |
| |___f_files
| | |____bdyini.F90
| | |____diaharm.F90
| | |____diaharm_fast.F90
| | |____dommsk.F90
| | |____dtatsd.F90
| | |____par_oce.F90
| | |____sbctide.F90
| | |____step.F90
| | |____step_oce.F90
| | |____tide_FES14.h90
| | |____tide_mod.F90
| | |____tideini.F90
| |
| |___p_files
| | |____scrip.patch
| | |____scripgrid.patch
| | |____scripinterp.patch
| | |____scripinterp_mod.patch
| | |____scripshape.patch
<<<<<<< HEAD
=======


>>>>>>> fd4ebfd3f245c028265f50995d167b3f6af98dd5
|
|____SCRIPTS
| |____load_modules_1.sh
| |____make_tools.sh
| |____create_coordinates.sh
| |____load_modules_2.sh
| |____main1.sh
| |____fix_elevation.sh
| |____make_directories.sh
| |____python_script.sh
| |____python_tide.sh
| |____scri.sh
| |____setup_python_obc.sh
| |____setup_python_tide.sh~
| |____setup_python_tide.sh
| |____interpolate_gebco.sh
| |____make_domain_cfg.sh
| |____make_nemo.sh
| |____make_paths.sh
| |____make_tides.sh
| |____make_xios.sh
| |____bdy_obc.m
| |____COPERNICUS_INTERP_SSH.m
| |____nemo_IC_temperature.m
| |____nemo_IC_salinity.m
| |____COPERNICUS_INTERP.m
| |____obc_Sal.m
| |____obc_U.m
| |____obc_V.m
| |____obc_Temp.m
| |____obc_SSH.m
| |____river_maker.m
| |____Coast_finder.m
| |____smooth2.m
|
|____README.md
</pre>
