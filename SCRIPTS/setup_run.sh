#---------	script for setting up the EXP_01 directory   ------------


cp $GFILE/RUN_FILES/* $EXP/

cd $EXP
mkdir restarts     #NEMO will crash if this folder does not exist, even when not needed
