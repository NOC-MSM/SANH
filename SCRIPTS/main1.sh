echo "Making Paths"
. ./make_paths.sh                                 > main_output.txt 2>&1
echo "Making Directories"
. ./make_directories.sh                          >> main_output.txt 2>&1
echo "Loading modules (Intel)"
. ./load_modules_1.sh                            >> main_output.txt 2>&1
echo "Installing XIOS_2.0 - this will take 5-10 mins"
. ./make_xios.sh                                 >> main_output.txt 2>&1
echo "Installing NEMO - this will take a good 10/15 mins - make sure you have an NEMO account!"
echo "WARNING - this automatically chooses OPA_SRC only"
echo "If you want to choose anything else e.g. LIM_SRC, remove the echo in make_nemo.sh"
. ./make_nemo.sh                                 >> main_output.txt 2>&1
echo "Compiling various grid tools"
. ./make_tools.sh                                >> main_output.txt 2>&1
echo "Creating coordinate file"
. ./create_coordinates.sh                        >> main_output.txt 2>&1
echo "Loading other netcdf modules"
. ./load_modules_2.sh                            >> main_output.txt 2>&1
echo "Removing land"
. ./fix_elevation.sh                             >> main_output.txt 2>&1
echo "Interpolating GEBCO on to our domain"
. ./interpolate_gebco.sh                         >> main_output.txt 2>&1
echo "We stop here. Inspect bathy_meter.nc in "
$DOMAIN
echo "Before continuing to make domain_cfg.nc in the next step."
