# sort_restart_files.py
#
# sort restart files
# jelt 31 May 2018

import re
import os
import datetime

# Get a list of files: `ls INDIAN_*_restart_0000.nc`
files = [f for f in os.listdir('.') if re.match(r'INDIAN_[0-9]+_restart_0000\.nc', f)]




def getdate( time_step_in ):
    """
    Usage: [nday, dat ] = getdate( time_step_in )
    """

    # Convert timestep to julian day. Initialise list with known values
    time_step = [0] * 2
    nday_year = [0] * 2
    date = [0] * 2

    # Time point One
    time_step[0] = 150721
    nday_year[0] = 108.
    date[0] = datetime.datetime(2016, 4, 17)
    # Time point TWO
    time_step[1] =  269761
    date[1] =  datetime.datetime(2016, 8, 19)
    nday_year[1] = 232.

    nday_year_out = (nday_year[1] - nday_year[0]) / (time_step[1] - time_step[0]) * (time_step_in - time_step[0]) + nday_year[0]
    date_out = (date[1] - date[0]) / (time_step[1] - time_step[0]) * (time_step_in - time_step[0]) + date[0]
    return nday_year_out, date_out


# Extract date and day number and move restarts to folder with date structure Y-m-d
for file in files:
    nstep = file.replace('INDIAN_','').replace('_restart_0000.nc', '')
    [nday, dat ] = getdate( int(nstep)+1 ) # +1 because the restarts were (all but a couple) written 1 timestep before midnight. The 'couple' were written just before notification
    print str(nstep), nday, dat.strftime("%Y-%m-%d")
    os.system('mkdir '+dat.strftime("%Y-%m-%d"))
    os.system('mv '+file.replace('restart_0000.nc','restart*nc')+' '+dat.strftime("%Y-%m-%d")+'/.' )
