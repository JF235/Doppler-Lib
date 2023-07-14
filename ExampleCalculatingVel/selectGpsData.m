%% Selecting data from GPS constelation

% Obtendo informações da Ephemeris da constelação GPS (.nav)
gpsData.gpsEphemeris = roverEphemeris.gpsEphemeris;
gpsData.satsIds = unique(gpsData.gpsEphemeris(1, :));

% Filtrando dados dos receptores fornecidos por GPS (.pos)
gpsData.groundObs = groundObs(groundObs.constID == 1, :);  
gpsData.roverObs = roverObs(roverObs.constID == 1, :);