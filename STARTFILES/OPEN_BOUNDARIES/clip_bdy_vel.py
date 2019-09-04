# clip_bdy_vel.py 
#
# Simple script to clip the velocity fields to make sure every thing stays sensible. 

import os

dst_path = '/projectsa/accord/SANH_jelt/INPUTS/'
files = []

#os.sytem('module load nco/gcc/4.4.2.ncwa')

yy_lst = ['16','17'] 
var_lst = [ 'U', 'V']
mon_lst = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
#mon_lst = [ 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV' ]
for yy in yy_lst:
  imm = 0 # 1 if SKIPPING JAN
  #print ' skipping JAN'
  for mm in mon_lst:
    imm = imm + 1 # month counter
    for var in var_lst:
      
      dst_name = 'SANH_bdy'+var+'_y20'+yy+'m'+"{0:0=2d}".format(imm)+'.nc'
      dst_file = dst_path+dst_name
      if var == 'V':
	fld = 'vomecrty'
      elif var == 'U':
	fld = 'vozocrtx'
      else:
	print 'panic'
      print ( 'ncap2 -O -s "where('+ fld +'<-0.5) '+fld+'=-0.5" '+dst_file+' '+dst_file+'.tmp' )
      os.system( 'ncap2 -O -s "where('+ fld +'<-0.5) '+fld+'=-0.5" '+dst_file+' '+dst_file+'.tmp' )
      print ( 'ncap2 -O -s "where('+ fld +'>0.5) '+ fld+'=0.5" '+dst_file+'.tmp '+dst_file+'.tmp' )
      os.system( 'ncap2 -O -s "where('+ fld +'>0.5) '+ fld+'=0.5" '+dst_file+'.tmp '+dst_file+'.tmp' )
      #print (' rsync -uvt '+dst_file+'.tmp jelt@login.archer.ac.uk:/work/n01/n01/jelt/BoBEAS/EXP_2016/OBC/'+dst_name )
      #os.system(' rsync -uvt '+dst_file+'.tmp jelt@login.archer.ac.uk:/work/n01/n01/jelt/BoBEAS/EXP_2016/OBC/'+dst_name )
      print('mv '+dst_file+'.tmp '+dst_file ) 
      os.system('mv '+dst_file+'.tmp '+dst_file ) 
