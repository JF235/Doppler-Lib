addpath("data\30_07_2021\")
addpath("gnssLib\")

%% Loading Data
groundEphemeris = readRinexNav("ground.nav");
roverEphemeris = readRinexNav("rover.nav");
[groundInitPos, groundObs, groundInterval] = readRinexObs("ground.obs");
[roverInitPos, roverObs, roverInterval] = readRinexObs("rover.obs");
groundObs = obs2table(groundObs);
roverObs = obs2table(roverObs);

%% Selecting data from GPS constelation
% Obtendo informações da Ephemeris da constelação GPS
gpsData.gpsEphemeris = roverEphemeris.gpsEphemeris;
gpsData.satsIds = unique(gpsData.gpsEphemeris(1, :));

% Filtrando dados .obs da constelação GPS.
gpsData.groundObs = groundObs(groundObs.constID == 1, :);  
gpsData.roverObs = roverObs(roverObs.constID == 1, :);

