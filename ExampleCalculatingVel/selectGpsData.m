%% Selecting data from GPS constelation

% Obtendo informações da Ephemeris da constelação GPS (.nav)
gpsData.gpsEphemeris = roverEphemeris.gpsEphemeris;
gpsData.satsIds = unique(gpsData.gpsEphemeris(1, :));

% Filtrando dados dos receptores fornecidos por GPS (.pos)
% obs.constID == obs(:, 3)
gpsData.groundObs = groundObs(groundObs(:, 3) == 1, :);  
gpsData.roverObs = roverObs(roverObs(:, 3) == 1, :);