clearvars; clc;

addpath('..')
addpath(genpath('../utilities/'));
addpath(genpath('../datasets/'));
addpath(genpath('../m_map/'));



%% STEP 1: set mesh extents and set parameters for mesh. 

bbox = [118.5 165;		% lon_min lon_max
        17.5 66.7]; 		% lat_min lat_max
min_el1    = 10e3;  		        % minimum resolution in meters.
max_el1    = 50e3; 		        % maximum resolution in meters. 
grade     = 0.35;               % mesh grade in decimal percent. 
R         = 3; 			        % Number of elements to resolve feature.
  
%% STEP 2: specify geographical datasets and process the geographical data
%% to be used later with other OceanMesh classes...
dem = 'depth_0090-05+06+07.nc'
coastline = 'coastline';
gdat1 = geodata('shp',coastline,'dem',dem,'h0',min_el1,...
                'bbox',bbox);
            
%% STEP 3: create an edge function class
fh1 = edgefx('geodata',gdat1,...
            'fs',R,...
            'max_el',max_el1,'g',grade);
          
%% Repeat STEPS 1-3 for a high resolution domain

min_el2    = 5e3;  	    % minimum resolution in meters.
max_el2    = 10e3;  	% maximum resolution in meters. 

%polygon boubox

x_bond_2 = [139.893800 137.827935 137.827935 139.893800 ...
            141.908628 141.908628 139.893800]
y_bond_2 = [33.460364 34.264115 35.722471 37.046551 ...
            35.722471 34.264115 33.460364]

bbox2 =[x_bond_2',y_bond_2'];

gdat2 = geodata('shp',coastline,'dem',dem,'h0',min_el2,'bbox',bbox2);

fh2 = edgefx('geodata',gdat2,...
            'fs',R, ...
            'max_el',max_el2,'g',grade);

min_el3    = 500;  	    % minimum resolution in meters.
max_el3    = 3e3;  	% maximum resolution in meters. 

%polygon boubox

x_bond_3 = [139.860601 139.377756 139.850854 140.334729 139.860601]
y_bond_3 = [34.820752 35.266955 35.899820 35.674759 34.820752]

bbox3 =[x_bond_3',y_bond_3'];

gdat3 = geodata('shp',coastline,'dem',dem,'h0',min_el3,'bbox',bbox3);

fh3 = edgefx('geodata',gdat3,...
            'fs',R, ...
            'max_el',max_el3,'g',grade);

min_el4    = 100;  	    % minimum resolution in meters.
max_el4    = 500;  	% maximum resolution in meters. 

%polygon boubox

x_bond_4 = [139.800170 139.639082 139.569917 139.740625 ...
            140.088244 139.890691 139.800170]
y_bond_4 = [35.181959 35.260841 35.458210 35.568259 ...
            35.523068 35.142872 35.181959]

bbox4 =[x_bond_4',y_bond_4'];

gdat4 = geodata('shp',coastline,'dem',dem,'h0',min_el4,'bbox',bbox4);

fh4 = edgefx('geodata',gdat4,...
            'fs',R, ...
            'max_el',max_el4,'g',grade);
        
min_el5    = 10;  	    % minimum resolution in meters.
max_el5    = 50;  	% maximum resolution in meters. 

%polygon boubox

x_bond_5 = [139.808543 139.807288 139.861876 139.853770 ...
            139.844903 139.810970 139.808543]
y_bond_5 = [35.326712 35.344750 35.348497 35.338520 ...
            35.321807 35.311823 35.326712]

bbox5 =[x_bond_5',y_bond_5'];

gdat5 = geodata('shp',coastline,'dem',dem,'h0',min_el5,'bbox',bbox5);

fh5 = edgefx('geodata',gdat5,...
            'fs',R, ...
            'max_el',max_el5,'g',grade);
        
        
%% STEP 4: Pass your edgefx class object along with some meshing options 
%% and build the mesh...
mshopts = meshgen('ef',{fh1 fh2 fh3 fh4 fh5},'bou',{gdat1 gdat2 gdat3 gdat4 gdat5},...
                  'plot_on',1,'nscreen',5,'proj','trans');
mshopts = mshopts.build; 

%% STEP 5: Plot and save the msh class object/write to fort.14
m = mshopts.grd; % get out the msh object
m = interp(m,{gdat1 gdat2 gdat3},'mindepth',0.05); % interpolate bathy to the mesh with minimum depth of 1 m
m = make_bc(m,'auto',gdat1);               % make the nodestring boundary conditions
% m = make_bc(m,'auto',gdat_01,'depth',20);
plot(m,'bd',1); % plot on native projection with nodestrings
plot(m,'b',1); % plot bathy on native projection
plot(m,'reso',1,[],[],[10, 0 10e3]) % plot the resolution
save('tokyo_Futtsu.mat','m'); 
write(m,'tokyo_Futtsu');