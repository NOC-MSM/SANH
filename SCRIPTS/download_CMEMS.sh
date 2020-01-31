# Script for downloading the hindcast CMEMS data 


#One file at a time: 

#set up environment:
#module load anaconda
#source activate motu_env2

#2016 example: 
#python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024 --longitude-min 55 --longitude-max 140 --latitude-min -25 --latitude-max 30 --date-min "2016-01-01 12:00:00" --date-max "2016-01-06 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --out-name "CMEMS_2016_01_01_download.nc" --user jjardine1 --pwd CMEMS_2019a


#1993:
#python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id GLOBAL_REANALYSIS_PHY_001_030-TDS --product-id global-reanalysis-phy-001-030-daily --longitude-min 55 --longitude-max 140 --latitude-min -25 --latitude-max 30 --date-min "1993-01-01 12:00:00" --date-max "1993-01-01 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --out-name "CMEMS_1993_01_01_download.nc" --user jjardine1 --pwd CMEMS_2019a


#CMEMS files per year

export CONFIG=CMEMS_SANH
export WORK=/projectsa/accord/SANH_jenjar
export CMEMS=$WORK/$CONFIG/CMEMS_data

cd $CMEMS

module load anaconda
source activate motu_env2

year="2002"
for mon in $(seq -f "%02g" 1 12)
do
if [ "$mon" = "01" -o "$mon" = "03" -o "$mon" = "05" -o "$mon" = "07" -o "$mon" = "08" -o "$mon" = "10" -o "$mon" = "12" ] 
then
echo $mon
 for day in $(seq -f "%02g" 1 31)
  do
  echo $day
python -m motuclient --motu http://my.cmems-du.eu/motu-web/Motu --service-id GLOBAL_REANALYSIS_PHY_001_030-TDS --product-id global-reanalysis-phy-001-030-daily --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "${year}-${mon}-${day} 12:00:00" --date-max "${year}-$mon-$day 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --out-name "CMEMS_${year}_${mon}_${day}_download.nc" --user jjardine1 --pwd CMEMS_2019a
done
fi
if [ "$mon" = "04" -o "$mon" = "06" -o "$mon" = "09" -o "$mon" = "11" ]
then
echo $mon
 for day in $(seq -f "%02g" 1 30)
  do
  echo $day
python -m motuclient --motu http://my.cmems-du.eu/motu-web/Motu --service-id GLOBAL_REANALYSIS_PHY_001_030-TDS --product-id global-reanalysis-phy-001-030-daily --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "${year}-${mon}-${day} 12:00:00" --date-max "${year}-$mon-$day 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --out-name "CMEMS_${year}_${mon}_${day}_download.nc" --user jjardine1 --pwd CMEMS_2019a  
done
fi
if [ "$mon" = "02" ]
then
echo $mon
 for day in $(seq -f "%02g" 1 28)
  do
  echo $day
python -m motuclient --motu http://my.cmems-du.eu/motu-web/Motu --service-id GLOBAL_REANALYSIS_PHY_001_030-TDS --product-id global-reanalysis-phy-001-030-daily --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "${year}-${mon}-${day} 12:00:00" --date-max "${year}-$mon-$day 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --out-name "CMEMS_${year}_${mon}_${day}_download.nc" --user jjardine1 --pwd CMEMS_2019a  
done
fi
done

#still need to download last of previous year and first of subsequent year

python -m motuclient --motu http://my.cmems-du.eu/motu-web/Motu --service-id GLOBAL_REANALYSIS_PHY_001_030-TDS --product-id global-reanalysis-phy-001-030-daily --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "2001-12-31 12:00:00" --date-max "2001-12-31 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --out-name "CMEMS_2001_12_31_download.nc" --user jjardine1 --pwd CMEMS_2019a

python -m motuclient --motu http://my.cmems-du.eu/motu-web/Motu --service-id GLOBAL_REANALYSIS_PHY_001_030-TDS --product-id global-reanalysis-phy-001-030-daily --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "2003-01-01 12:00:00" --date-max "2003-01-01 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --out-name "CMEMS_2003_01_01_download.nc" --user jjardine1 --pwd CMEMS_2019a

conda  deactivate
cd ..
