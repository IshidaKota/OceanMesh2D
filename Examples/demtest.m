clearvars; clc;

addpath('..')
addpath(genpath('../utilities/'))
addpath(genpath('../datasets/'))   %使いたいデータはdatassetsに移動する
addpath(genpath('../m_map/'))

bbox=[138 141;
      34 37]; %東京湾周辺で出力できるか確認
min_el=30;
coastline='GSHHS_f_L1';
dem='SRTM15+.nc';

gdat=geodata('shp',coastline,'dem',dem,'bbox',bbox,'h0',min_el);
plot(gdat,'dem');