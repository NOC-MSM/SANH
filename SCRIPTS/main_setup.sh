echo "Making Paths"
. ./make_paths.sh                                 > main_output.txt 2>&1

echo "Making Directories"
. ./make_directories.sh                          >> main_output.txt 2>&1

echo "Loading modules (Intel)"
. ./load_modules_1.sh                            >> main_output.txt 2>&1

echo "Installing XIOS_2.0 - this will take 5-10 mins"
. ./make_xios.sh                                 >> main_output.txt 2>&1

echo "Installing NEMO - this will take a good 10/15 mins!"
echo "WARNING - this automatically chooses OPA_SRC only"
echo "If you want to choose anything else e.g. LIM_SRC, remove the echo in make_nemo.sh"
. ./make_nemo.sh                                 >> main_output.txt 2>&1


. ./transfer_data.sh
echo "Transferring larger data files"


echo "DONE"
