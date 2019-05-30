import os

src_path = '/projectsa/NEMO/ash/NEMO_INDIA/BOUNDARY_FORCING/' 
dst_path = '/projectsa/accord/BoBEAS/INPUTS/'
files = []

os.sytem('module load nco/gcc/4.4.2.ncwa')

yy_lst = ['16', '17'] 
var_lst = ['SAL', 'TEMP', 'SSH', 'U0', 'V0']
mon_lst = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
#mon_lst = [ 'MAR', 'APR', 'MAY']
for yy in yy_lst:
  for var in var_lst:
    imm = 0
    for mm in mon_lst:
      imm = imm + 1 # month counter
      src_dir = src_path + var+yy+ str('_dir/') + mm+'/'
      dst_file = dst_path+'20'+yy+'/' + var+'_20'+yy+"{0:0=2d}".format(imm)+'.nc'
      os.system('rm -f '+dst_file)
      os.system('ncrcat -h '+src_dir+'*.nc '+dst_file ) 
