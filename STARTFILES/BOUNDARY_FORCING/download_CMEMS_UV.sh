# Script for downloading the hindcast CMEMS data 


#One file at a time: 

#2016 example: 
#python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024 --longitude-min 55 --longitude-max 140 --latitude-min -25 --latitude-max 30 --date-min "2016-01-01 12:00:00" --date-max "2016-01-06 12:00:00" --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --out-name "CMEMS_2016_01_01_download.nc" --user USERNAME --pwd PASSWORD



#CMEMS files per year

export CONFIG=CMEMS_SANH
export WORK=/projectsa/accord/SANH_jenjar
export CMEMS=$WORK/$CONFIG/UV_components

cd $CMEMS

module load anaconda
conda activate motu_env2

year="1994"
for mon in $(seq -f "%02g" 1 12)
do
if [ "$mon" = "05" -o "$mon" = "07" -o "$mon" = "08" -o "$mon" = "10" -o "$mon" = "12" ] 
then
echo $mon
 for day in $(seq -f "%02g" 1 31)
  do
  echo $day
python -m motuclient --motu https://my.cmems-du.eu/motu-web/Motu --service-id GLOBAL_MULTIYEAR_PHY_001_030-TDS --product-id cmems_mod_glo_phy_my_0.083_P1D-m --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "${year}-${mon}-${day} 12:00:00" --date-max "${year}-${mon}-${day} 12:00:00" --depth-min 0.49402499198913574 --depth-max 5727.9169921875 --variable uo --variable vo --out-name "CMEMS_${year}-${mon}-${day}_download_UV.nc" --user USERNAME --pwd PASSWORD
done
fi
if [ "$mon" = "04" -o "$mon" = "06" -o "$mon" = "09" -o "$mon" = "11" ]
then
echo $mon
 for day in $(seq -f "%02g" 1 30)
  do
  echo $day
python -m motuclient --motu https://my.cmems-du.eu/motu-web/Motu --service-id GLOBAL_MULTIYEAR_PHY_001_030-TDS --product-id cmems_mod_glo_phy_my_0.083_P1D-m --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "${year}-${mon}-${day} 12:00:00" --date-max "${year}-${mon}-${day} 12:00:00" --depth-min 0.49402499198913574 --depth-max 5727.9169921875 --variable uo --variable vo --out-name "CMEMS_${year}-${mon}-${day}_download_UV.nc" --user USERNAME --pwd PASSWORD
done
fi
if [ "$mon" = "02" ]
then
echo $mon
 for day in $(seq -f "%02g" 1 28)
  do
  echo $day
python -m motuclient --motu https://my.cmems-du.eu/motu-web/Motu --service-id GLOBAL_MULTIYEAR_PHY_001_030-TDS --product-id cmems_mod_glo_phy_my_0.083_P1D-m --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "${year}-${mon}-${day} 12:00:00" --date-max "${year}-${mon}-${day} 12:00:00" --depth-min 0.49402499198913574 --depth-max 5727.9169921875 --variable uo --variable vo --out-name "CMEMS_${year}-${mon}-${day}_download_UV.nc" --user USERNAME --pwd PASSWORD

done
fi
done

#still need to download last of previous year and first of subsequent year
python -m motuclient --motu https://my.cmems-du.eu/motu-web/Motu --service-id GLOBAL_MULTIYEAR_PHY_001_030-TDS --product-id cmems_mod_glo_phy_my_0.083_P1D-m --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "1994-12-31 12:00:00" --date-max "1994-12-31 12:00:00" --depth-min 0.49402499198913574 --depth-max 5727.9169921875 --variable uo --variable vo --out-name "CMEMS_1994-12-31_download_UV.nc" --user USERNAME --pwd PASSWORD



#still need to download last of previous year and first of subsequent year
python -m motuclient --motu https://my.cmems-du.eu/motu-web/Motu --service-id GLOBAL_MULTIYEAR_PHY_001_030-TDS --product-id cmems_mod_glo_phy_my_0.083deg_P1D-m --longitude-min 50 --longitude-max 115 --latitude-min -10 --latitude-max 30 --date-min "1995-01-01 12:00:00" --date-max "1995-01-01 12:00:00" --depth-min 0.49402499198913574 --depth-max 5727.9169921875 --variable uo --variable vo --out-name "CMEMS_1995-01-01_download_UV.nc" --user USERNAME --pwd PASSWORD



cd ..
