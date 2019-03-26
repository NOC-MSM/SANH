# NEMO_cfgs
NEMO BoBEAS configuration

Each configuration directory should be laid out in the following manner, to
facilitate configuration archival and sharing:

<pre>
BoBEAS
|____NAMELISTS_AND_FORTRAN_FILES
| |----namelist_cfg
| |----namelist_ref
|
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
|____README.md
</pre>
