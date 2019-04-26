#
#====================== DOCSTRING ============================
"""
Generate ERA5 atmospheric forcing for NEMO
So far to prduce a year by a year - need to be automated
--------------------------------------------------------------
"""
__author__      = "Nicolas Bruneau"
__copyright__   = "Copyright 2018, NOC"
__email__       = "nibrun@noc.ac.uk"
__date__        = "2018-05"

#====================== USR PARAMS ===========================

Year_init    = 2016                              ## First year to process          
Year_end     = 2017                              ## Last one [included]
East         =   110                              ## East Border
West         =   60                              ## West Border
North        =   30                              ## North Border
South        =   0                              ## South Border
path_ERA5    = '/projectsa/NEMO/Forcing/ERA5/'   ## ROOT PATH OD ERA5 DATA
path_EXTRACT = './EXTRACTION_AMM7/'              ## WHERE TO EXTRACT YOUR REGION
path_FORCING = './FORCING/'                      ## NEMO FORCING
clean        = False                             ## Clean extraction (longest bit)
sph_ON       = True                              ## Compute specific humidity or not

#================== NEMO DOCUMENTATION =======================

"""
See the manual in section SBC for more details on the way data
are used in NEMO
The time variable from the netcdf is not used
"""

#====================== LOAD MODULES =========================

import os, sys, glob
import subprocess
import numpy as np
import datetime
from   netCDF4 import Dataset, MFDataset
import netcdftime
import matplotlib.pyplot as plt
from   matplotlib.mlab import griddata
import scipy.spatial.qhull as qhull

#====================== VARIABLE DEF =========================

var_path = { 't2m'  : 'INST',  \
             'msl'  : 'INST',  \
             'u10'  : 'INST',  \
             'v10'  : 'INST',  \
             'strd' : "CUMUL", \
             'ssrd' : "CUMUL", \
             'sf'   : "CUMUL", \
             'tp'   : "CUMUL", \
           }

#var_path = { 'msl'  : 'INST',  \
#             'u10'  : 'INST',  \
#             'strd' : "CUMUL", \
#             'ssrd' : "CUMUL", \
#             'sf'   : "CUMUL", \
#           }

#var_path = { 't2m'  : 'INST',  \
#             'v10'  : 'INST',  \
#             'tp'   : "CUMUL", \
#          }


if sph_ON :
   var_path[ 'sp'  ] = 'INST'
   var_path[ 'd2m' ] = 'INST'

#===================== INTERNAL FCTNS ========================

help_tosec = np.vectorize( lambda x : x.total_seconds() )

def Read_NetCDF( fname, KeyVar ) : 
    'Read NetCDF file'

    if "*" in fname : nc = MFDataset( fname, 'r' )
    else            : nc =   Dataset( fname, 'r' )

    ## Get time using the time variable
    Time_Var = nc.variables[ 'time']
    dt = Time_Var[:][1] - Time_Var[:][0]
    Time_H   = np.arange( Time_Var[:][0], Time_Var[:][0]+dt*Time_Var[:].size, dt ) 
    try :    Tref = netcdftime.utime( Time_Var.units, calendar = Time_Var.calendar )
    except : Tref = netcdftime.utime( Time_Var.units, calendar = "gregorian" )
    Time = Tref.num2date( Time_H )
    print "====================++++"

    ## Get Coordinates
    try :
       Lon = nc.variables[ 'longitude' ][:]
       Lat = nc.variables[ 'latitude' ][:]
       LON, LAT = np.meshgrid( Lon, Lat )
    except :
       LON = nc.variables[ 'lon' ][:]
       LAT = nc.variables[ 'lat' ][:]

    ## Get Variable
    dum = nc.variables[ KeyVar ]
    Var = dum[:]
    ind = ( Var == dum._FillValue )
    Var[ind] = np.nan 
    #Var = Var / dum.scale_factor + dum.add_offset
    ind = (np.isnan(Var))
    Var[ind] = -9999999

    print Time[0], Time[-1], Var.shape, Time.shape, np.sum(ind)
    try    : return Time, LON, LAT, Var, dum.units, dum.long_name
    except : return Time, LON, LAT, Var, dum.units, dum.standard_name

#=================== MANIPULATE NetCDF =======================

def compute_scale_and_offset( Var, n ):
    'http://james.hiebert.name/blog/work/2015/04/18/NetCDF-Scale-Factors/'
    Vmin = np.nanmin( Var )
    Vmax = np.nanmax( Var )
    print "scaleoffset", Vmin, Vmax
    # stretch/compress data to the available packed range
    scale_factor = (Vmax - Vmin) / (2 ** n - 1)
    # translate the range to be symmetric about zero
    add_offset = Vmin + 2 ** (n - 1) * scale_factor
    return scale_factor, add_offset

def Add_Variable( nc, vName, vDim, vVal, long_name=None, units=None, standard_name=None, fill_value=None) :
    "Add a variable with its attributes in a netcdf file"
    if vName not in ['time','lon','lat',] : fprec = 'i'
    else : fprec = 'f8'

    if fill_value != None : nc.createVariable( vName, fprec, vDim, fill_value=fill_value, zlib=True, complevel=5 )
    else                  : nc.createVariable( vName, fprec, vDim, zlib=True, complevel=5 )
    if long_name     != None : nc.variables[ vName ].long_name     = long_name
    if units         != None : nc.variables[ vName ].units         = units
    if standard_name != None : nc.variables[ vName ].standard_name = standard_name
    if vName not in ['time','lon','lat',] :
       sc, off = compute_scale_and_offset( vVal, 16 )
       nc.variables[ vName ].scale_factor = sc
       nc.variables[ vName ].add_offset   = off

    nc.variables[ vName ][:] = vVal   # np.floor((vVal-off)/sc)

def Create_Dimensions( nc, lon_name, nLon, lat_name, nLat ) :
    "Create NetCDF dimensions time, nx, ny"
    nc.createDimension( lon_name , nLon )
    nc.createDimension( lat_name , nLat )
    nc.createDimension( 'time'   , None )

def Create_NetCDF_core( nc, tDim, tRef, tVal, sDim, sVal_lon, sVal_lat ) :
    "Create Lon, Lat and Time variables"
    # WRITE TIME INFO
    tUnit = "days since {0} UTC".format( tRef.strftime( "%Y-%m-%d %H:%M:%S" ) ); tCal  = "standard"
    Tref  = netcdftime.utime( tUnit, calendar = tCal )
    Add_Variable( nc, 'time', ('time'), Tref.date2num( tVal ), \
                  long_name = "time since {0}".format(tUnit) , \
                  units = tUnit )
    nc.variables['time'].calendar  = tCal
    #nc.variables['time'].base_date = np.array( [ tRef.year, tRef.month, tRef.day, tRef.hour ] )

    # WRITE LON INFO
    Add_Variable( nc, 'lon', sDim, sVal_lon, long_name = 'Longitude', \
                  units = 'degree_east', standard_name = 'longitude'  )

    # WRITE L INFOT
    Add_Variable( nc, 'lat', sDim, sVal_lat, long_name = 'Latitude', \
                  units = 'degree_north', standard_name = 'latitude' )

def Create_Attributes( nc ) :
    "Add some info - I do it at the end as I had issue with not properly readable netcdf if not"
    nc.Description = 'ERA5 Atmospheric conditions for AMM15 NEMO3.6'
    nc.Author      = 'Prepare_ERA5.py'
    nc.Created     = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    nc.Conventions = "CF-1.0"
    nc.close()

#======================= EXTRACTION ==========================

def Extract( fin, fout, clean=True ) :
    if clean : os.system( "rm {0}".format( fout ) )
    if not os.path.exists( fout ) :
       command = "ncks -d latitude,{0},{1} -d longitude,{2},{3} {4} {5}".format( np.float(South), np.float(North),\
                                                                                 np.float(West), np.float(East), fin, fout )
       print command
       os.system( command )
      
def datetime_range(start, end, delta):
    current = [start, ]
    while current[-1] < end:
        current.append( current[-1]+delta )
    return np.array(current)

#======================= CORE PROGR ==========================

## load NCO
os.system( "module load nco/gcc/4.4.2.ncwa" )
os.system( "mkdir {0} {1}".format( path_EXTRACT, path_FORCING ) )
if West < 0 : West = 360.+West
if East < 0 : East = 360.+East

## Loop over each variable
for iVar, pVar in var_path.iteritems() :

    print "================== {0} - {1} ==================".format( iVar, pVar )

    ##---------- EXTRACT ALL DATA FOR DOMAIN ----------------
    for iY in range( Year_init, Year_end+1 ) :
        ## Files
        finput  = "{0}/{1}/{2}/{2}_{3}.nc".format( path_ERA5, pVar, iVar, iY )
        foutput = "./{2}/{0}_{1}.nc".format( iVar, iY, path_EXTRACT )
        ## Extract the subdomain
        Extract( finput, foutput, clean=clean ) 

    ##---------- LOAD FULLL TIME SERIES IN MEMORY -----------
    Time, Lon, Lat, dum, Units, Name = Read_NetCDF( "./{1}/{0}_*.nc".format( iVar, path_EXTRACT ), iVar )
    dt  = Time[1] - Time[0]   ## assume to be constant in time
    dt2 = datetime.timedelta( seconds=dt.total_seconds() / 2. )

    ##---------- SOME PREPROCESSING -------------------------
    if pVar == 'INST' :
       ## Add time step for last hour - copy the last input
       dumA  = np.concatenate( [  dum,  dum[-1][np.newaxis,...] ], axis = 0 )
       TimeA = np.array( Time.tolist() + [Time[-1],]  )

       ## instantaneous field every hour. we center it in mid-time step (00:30) as it
       ## is what NEMO assumes according to documentation
       dumC  = ( dumA[0:-1] + dumA[1::] ) / 2.0   
       TimeC =  TimeA[0:-1] + dt2           ## shift half time step positively due to averaging
       suffix = ''

    elif pVar == 'CUMUL' :
       ## Add time step for first 6h - copy the first input
       nshift = 6
       dumA = np.repeat( dum[None,0,...], nshift, axis=0 ) 
       dumA = np.concatenate( [dumA,dum], axis = 0 )       
       TimeA = np.array( [ Time[0]-dt*(nshift-i) for i in range(nshift) ] ) 
       TimeA = np.concatenate( [TimeA, Time], axis = 0 )

       ## Cumulated field comes from forecast and are therefore shifter in time
       ## we need to account for it properly for the beginning of the time series.
       ## first value is reapeated
       dumC  = dumA  / dt.total_seconds()    ## convert as a rate
       TimeC = TimeA - dt2                   ## shift half time step negatively as cumulated period
       suffix = '/s'

       if iVar in [ 'sf', 'tp', ]:
          print "convert m to mm for", iVar
          dumC *= 1000.
          Units = 'mm'

       if iVar in [ 'ssrd', 'strd', ]:
          dumC[(dumC<0.)] = 0.
          print "negative values set to 0", iVar

    else :
       print "Values in var_path variables are expected to be CUMUL or INST"
       print "  given {0} for {1}".format( pVar, iVar )
       sys.exit()

    ##---------- OUTPUT A FILE PER YEAR ---------------------
    for iY in range( Year_init, Year_end+1 ) :

        indT = ( TimeC >= datetime.datetime( iY  ,1,1 ) ) \
             * ( TimeC <  datetime.datetime( iY+1,1,1 ) )
 
        if iVar in [ "d2m", "sp" ] :
               Fout = "./{2}/forSPH_ERA5_{0}_y{1}.nc".format( iVar.upper(), iY, path_FORCING )
        else : Fout = "./{2}/ERA5_{0}_y{1}.nc".format( iVar.upper(), iY, path_FORCING )
        nc = Dataset( Fout, 'w', format='NETCDF4_CLASSIC')
        Create_Dimensions ( nc, 'nLon', Lon.shape[1], 'nLat' , Lat.shape[0] )
        Create_NetCDF_core( nc, ('time'), TimeC[indT][0], TimeC[indT], ('nLat', 'nLon'), Lon[::-1,:], Lat[::-1,:] )
        Add_Variable( nc, iVar.upper(), ( 'time', 'nLat', 'nLon'), dumC[indT,::-1,:], units=Units+suffix, standard_name=Name, fill_value=-999999 )
        Create_Attributes( nc )


##---------- PROCESS SPECIFIC HUMIDITY ----------------------     
## Compute Specific Humidity according to ECMWF documentation

if sph_ON : 

   for iY in range( Year_init, Year_end+1 ) :
       Time, Lon, Lat, d2m, dUnits, dName = Read_NetCDF( "./{1}/forSPH_ERA5_D2M_y{0}.nc".format( iY, path_FORCING ), 'D2M' )
       Time, Lon, Lat, sp , dUnits, dName = Read_NetCDF( "./{1}/forSPH_ERA5_SP_y{0}.nc" .format( iY, path_FORCING ), 'SP'  )
       esat = 611.21 * np.exp( 17.502 * (d2m-273.16) / (d2m-32.19) )
       dyrvap = 287.0597 / 461.5250
       dVar = dyrvap * esat / ( sp - (1-dyrvap) * esat)
       Units = "1"; Name = "Specific Humidity"

       indT = ( Time >= datetime.datetime( iY  ,1,1 ) ) \
            * ( Time <  datetime.datetime( iY+1,1,1 ) )

       Fout = "./{1}/ERA5_SPH_y{0}.nc".format( iY, path_FORCING )
       nc = Dataset( Fout, 'w', format='NETCDF4_CLASSIC')
       Create_Dimensions ( nc, 'nLon', Lon.shape[1], 'nLat' , Lat.shape[0] )
       Create_NetCDF_core( nc, ('time'), Time[indT][0], Time[indT], ('nLat', 'nLon'), Lon[:,:], Lat[:,:] )
       Add_Variable( nc, "SPH", ( 'time', 'nLat', 'nLon'), dVar[indT,:,:], units=Units, standard_name=Name, fill_value=-999999 )
       Create_Attributes( nc )


##---------- WRITE NAMELIST ---------------------------------

print "\n EXAMPLE of core namelist with ERA5 for NEMO"
print " the interpolation weights need to be generated using the usual method"
print " using: scripgrid.exe, scrip.exe, scripshape.exe from TOOLS/WEIGHTS/\n"

print "   &namsbc_core"
print "   cn_dir='./fluxes_ERA5/',"
print "   ln_taudif=.false.,"
print "   rn_pfac = 1.0,"
print "   rn_vfac = 1.,"
print "   rn_zqt = 2.,"
print "   rn_zu  = 10.,"
print "   sn_humi='ERA5_SPH' ,1,'SPH' ,.true.,.false.,'yearly','weights_era5_amm15_bicubic.nc','',"
print "   sn_prec='ERA5_TP'  ,1,'TP'  ,.true.,.false.,'yearly','weights_era5_amm15_bicubic.nc','',"
print "   sn_qlw ='ERA5_STRD',1,'STRD',.true.,.false.,'yearly','weights_era5_amm15_bicubic.nc','',"
print "   sn_qsr ='ERA5_SSRD',1,'SSRD',.true.,.false.,'yearly','weights_era5_amm15_bicubic.nc','',"
print "   sn_snow='ERA5_SF'  ,1,'SF'  ,.true.,.false.,'yearly','weights_era5_amm15_bicubic.nc','',"
print "   sn_tair='ERA5_T2M' ,1,'T2M' ,.true.,.false.,'yearly','weights_era5_amm15_bicubic.nc','',"
print "   sn_wndi='ERA5_U10' ,1,'U10' ,.true.,.false.,'yearly','weights_era5_amm15_bicubic.nc','U1',"
print "   sn_wndj='ERA5_V10' ,1,'V10' ,.true.,.false.,'yearly','weights_era5_amm15_bicubic.nc','V1',"
print "   /\n"

sys.exit()

