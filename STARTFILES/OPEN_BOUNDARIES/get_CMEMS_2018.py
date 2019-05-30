# Script to sequentially get a year of CMEMS-Copernicus data and save a one file per variable-month
# Check if file exists before downloading
# JPolton 24 May 2019
import os

dst_path = '/projectsa/accord/BoBEAS/INPUTS/'

yy_lst = ['18']
var_str = ['SAL', 'TEMP', 'SSH', 'U0', 'V0']
var_lst = ['so', 'thetao', 'zos', 'uo', 'vo']
mon_lst = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
ndays_lst = ['31', '28', '31',  '30',  '31',  '30',  '31',   '31',  '30',  '31' , '30', '31']
# Component of the get command that are fixed for BoBEAS
basic_cmd = 'python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024 '
latlon_rng = ' --longitude-min 60 --longitude-max 110 --latitude-min 0 --latitude-max 30'
# Component of the get command that are NOT fixed for BoBEAS
user_cred = ' --user jpolton --pwd JeffPCMEMS2018'
date_rng = ' --date-min "2018-01-01 12:00:00" --date-max "2019-05-10 12:00:00" '
depth_rng = ' --depth-min 0.493 --depth-max 5727.918000000001 '
var = ' --variable thetao '
ofile = ' --out-name CMEMS_2019-03-31_2019-05-10_download_T.nc '

for yy in yy_lst:
  if yy == '18':
    ndays_lst[1] = '29'
  else:
    ndays_lst[1] = '28'

  for ivar in range(len(var_lst)):
    var = ' --variable '+var_lst[ivar]

    for imm in range(len(mon_lst)):
      ndays = ndays_lst[imm]
      date_rng = ' --date-min "20'+yy+'-'+"{0:0=2d}".format(imm+1)+'-01 12:00:00" --date-max "20'+yy+'-'+"{0:0=2d}".format(imm+1)+'-'+ndays+' 12:00:00" '

      fname = dst_path+'20'+yy+'/'+var_str[ivar]+'_20'+yy+"{0:0=2d}".format(imm+1)+'.nc'
      if not os.path.isfile(fname):
        ofile = ' --out-name '+fname 
        os.system(  basic_cmd+latlon_rng+user_cred+depth_rng + date_rng+var+ofile )
      else:
 	print fname+': file already downloaded\n'

