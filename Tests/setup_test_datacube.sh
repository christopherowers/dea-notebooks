#!/usr/bin/env bash
set -ex

# Setup datacube
datacube system init --no-default-types --no-init-users
# Setup metadata types
datacube metadata add "$METADATA_CATALOG"
# Index products we care about for dea-notebooks
wget "$PRODUCT_CATALOG" -O product_list.csv

bash -c "tail -n+2 product_list.csv | grep 'ls7_nbart_geomedian_annual\|ls8_nbart_geomedian_annual\|ga_ls_wo_3\|s2a_ard_granule\|s2b_ard_granule\|ga_ls5t_ard_3\|ga_ls7e_ard_3\|ga_ls8c_ard_3\|wofs_annual_summary' | awk -F , '{print \$2}' | xargs datacube -v product add" 

# Index scenes
cat > index_tiles.sh <<EOF
s3-to-dc 's3://dea-public-data/geomedian-australia/v2.1.0/L7/x_20/y_-32/2015/01/01/*.yaml' --no-sign-request --skip-lineage 'ls7_nbart_geomedian_annual'
s3-to-dc 's3://dea-public-data/geomedian-australia/v2.1.0/L8/x_20/y_-32/2013/01/01/*.yaml' --no-sign-request --skip-lineage 'ls8_nbart_geomedian_annual'
s3-to-dc 's3://dea-public-data/geomedian-australia/v2.1.0/L8/x_20/y_-32/2014/01/01/*.yaml' --no-sign-request --skip-lineage 'ls8_nbart_geomedian_annual'
s3-to-dc 's3://dea-public-data/geomedian-australia/v2.1.0/L8/x_20/y_-32/2015/01/01/*.yaml' --no-sign-request --skip-lineage 'ls8_nbart_geomedian_annual'
s3-to-dc 's3://dea-public-data/geomedian-australia/v2.1.0/L8/x_20/y_-32/2016/01/01/*.yaml' --no-sign-request --skip-lineage 'ls8_nbart_geomedian_annual'
s3-to-dc 's3://dea-public-data/geomedian-australia/v2.1.0/L8/x_20/y_-32/2017/01/01/*.yaml' --no-sign-request --skip-lineage 'ls8_nbart_geomedian_annual'
# s3-to-dc 's3://dea-public-data/baseline/s2a_ard_granule/2018-09-09/S2A_OPER_MSI_ARD_TL_EPAE_20180909T020622_A016787_T55LBD_N02.06/*.yaml' --no-sign-request --skip-lineage 's2a_ard_granule'
# s3-to-dc 's3://dea-public-data/baseline/s2a_ard_granule/2018-09-19/S2A_OPER_MSI_ARD_TL_EPAE_20180919T021041_A016930_T55LBD_N02.06/*.yaml' --no-sign-request --skip-lineage 's2a_ard_granule'
# s3-to-dc 's3://dea-public-data/baseline/s2a_ard_granule/2018-09-29/S2A_OPER_MSI_ARD_TL_EPAE_20180929T020742_A017073_T55LBD_N02.06/*.yaml' --no-sign-request --skip-lineage 's2a_ard_granule'
# s3-to-dc 's3://dea-public-data/baseline/s2a_ard_granule/2018-10-09/S2A_OPER_MSI_ARD_TL_EPAE_20181009T021157_A017216_T55LBD_N02.06/*.yaml' --no-sign-request --skip-lineage 's2a_ard_granule'
# s3-to-dc 's3://dea-public-data/baseline/s2a_ard_granule/2018-10-19/S2A_OPER_MSI_ARD_TL_EPAE_20181019T021416_A017359_T55LBD_N02.06/*.yaml' --no-sign-request --skip-lineage 's2a_ard_granule'
# s3-to-dc 's3://dea-public-data/baseline/s2a_ard_granule/2018-10-29/S2A_OPER_MSI_ARD_TL_EPAE_20181029T021107_A017502_T55LBD_N02.06/*.yaml' --no-sign-request --skip-lineage 's2a_ard_granule'
# s3-to-dc 's3://dea-public-data/baseline/s2a_ard_granule/2018-11-08/S2A_OPER_MSI_ARD_TL_EPAE_20181108T021044_A017645_T55LBD_N02.07/*.yaml' --no-sign-request --skip-lineage 's2a_ard_granule'
# s3-to-dc 's3://dea-public-data/baseline/s2a_ard_granule/2018-11-18/S2A_OPER_MSI_ARD_TL_EPAE_20181118T021103_A017788_T55LBD_N02.07/*.yaml' --no-sign-request --skip-lineage 's2a_ard_granule'
# s3-to-dc 's3://dea-public-data/baseline/s2a_ard_granule/2018-11-28/S2A_OPER_MSI_ARD_TL_EPAE_20181128T020701_A017931_T55LBD_N02.07/*.yaml' --no-sign-request --skip-lineage 's2a_ard_granule'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2019/06/19/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2021/06/24/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2021/06/15/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2021/06/08/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2021/07/01/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/072/2020/10/02/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2019/03/31/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2019/01/26/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2021/04/12/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2021/03/27/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/072/2019/01/01/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2021/02/23/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2020/09/25/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/072/2020/07/14/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2021/09/28/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2020/12/21/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2019/05/18/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2020/12/30/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/072/2021/07/17/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/072/2020/05/11/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2021/05/23/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2020/04/25/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/072/2020/06/12/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2019/10/25/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2019/12/19/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2020/02/05/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/110/073/2019/11/26/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/072/2019/07/12/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/072/2019/06/26/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2019/06/10/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2019/08/29/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
# s3-to-dc 's3://dea-public-data/baseline/ga_ls8c_ard_3/111/073/2020/02/21/*.json' --no-sign-request --skip-lineage --stac 'ga_ls8c_ard_3'
EOF

cat index_tiles.sh | bash
