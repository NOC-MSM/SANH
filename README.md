# NEMO_cfgs
NEMO BoBEAS configuration

Each configuration directory should be laid out in the following manner, to
facilitate configuration archival and sharing:

<pre>
BoBEAS
|____SCRIPTS
| |----main1.sh
| |----make_paths.sh
| |----make_directories.sh
| |----load_modules_1.sh
| |----make_xios.sh
| |----make_nemo.sh
| |----make_tools.sh
| |----create_coordinates.sh
| |----load_modules_2.sh
| |----fix_elevations.sh
| |____interpolate_gebco.sh
|
|____ARCH
| |____arch-XC_ARCHER.fcm
|____arch_xios
| |____arch-XC_ARCHER.env
| |____arch-XC_ARCHER.fcm
| |____arch-XC_ARCHER.path
|____cpp_MYCONFIG.fcm
!____EXP_README.txt
|____EXP00
| |____1_namelist_cfg
| |____1_namelist_ice_cfg
| |____1_namelist_ice_ref
| |____1_namelist_ref
| |____context_nemo.xml
| |____domain_def_nemo.xml
| |____field_def_nemo-lim.xml
| |____field_def_nemo-opa.xml
| |____field_def_nemo-pisces.xml
| |____file_def_nemo.xml
| |____iodef.xml
| |____namelist_cfg
| |____namelist_ice_cfg
| |____namelist_ice_ref
| |____namelist_pisces_cfg
| |____namelist_pisces_ref
| |____namelist_ref
| |____namelist_top_cfg
| |____namelist_top_ref
| |____runscript
|____MY_SRC
| |____*.F90
|____INPUTS
| |____namelist.bdy
|____README.md
</pre>