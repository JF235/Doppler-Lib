% Selecionando dados em um determinado tempo
% 1. Posição do receptor (.pos)
% 2. Posições dos satélites (.nav > Ephemeris GPS)
% 3. Velocidades dos satélites (.nav > Ephemeris GPS)
% 4. Comprimento de onda dos satélites (Constante)
% 5. Efeito Doppler de cada satélite (.obs > Rover)

addpath("data\09_02_2022\")
addpath("gnssLib\")

%% Reading Data

% Nav
groundEphemeris = readRinexNav("ground.nav");
roverEphemeris = readRinexNav("rover.nav");
% Obs
[groundInitPos, groundObs, groundInterval] = readRinexObs("ground.obs");
[roverInitPos, roverObs, roverInterval] = readRinexObs("rover.obs");
groundObs = obs2table(groundObs);
roverObs = obs2table(roverObs);
% Pos
[posData, ti, tf, freqGnss] = readPos("rover.pos");
posData = pos2table(posData);

%% Selecting data from GPS constelation

% Obtendo informações da Ephemeris da constelação GPS (.nav)
gpsData.gpsEphemeris = roverEphemeris.gpsEphemeris;
gpsData.satsIds = unique(gpsData.gpsEphemeris(1, :));

% Filtrando dados dos receptores fornecidos por GPS (.pos)
gpsData.groundObs = groundObs(groundObs.constID == 1, :);  
gpsData.roverObs = roverObs(roverObs.constID == 1, :);

%% Obtendo informações em um tempo específico T
T = 300500;
idxT = find(posData.time == T);

%% 1. Posição do Receptor (.pos)
rec_pos = [ posData.xecef(posData.time == T);
            posData.yecef(posData.time == T);
            posData.zecef(posData.time == T) ];

%% 2 e 3. Posição e velocidade dos satélites (.nav > Ephemeris GPS)

% Selecionandos os satélites...
roverObs_gps = gpsData.roverObs;
roverObsT = roverObs_gps(roverObs_gps.time == T, :);
satsIds = roverObsT.satID;
noSats = length(satsIds);
%%
% ...obtendo posição e velocidade de cada.
satsPos = zeros(3,noSats);
satsVel = zeros(3,noSats);
gpsEphemeris = gpsData.gpsEphemeris;
for k=1:noSats
    idxs = find(gpsEphemeris(1, :) == satsIds(k));
    satEphemeris = gpsEphemeris(:, idxs);
    [~, j] = min(abs(T - satEphemeris(23, :)));
    satEphemeris = satEphemeris(:, j);
    [satsPos(:, k),~,~,satsVel(:, k)] = satPosition(satEphemeris, T);
end

%% 4. Comprimento de onda
wavelength = 2.99792458e8/1.57542*1e9;

%% 5. Efeito Doppler de cada satélite
% Raw Doppler
dopplers = roverObsT.doppler;

%% Empacotando informação
observation.time = T;
observation.satsPos = satsPos;
observation.satsVel = satsVel;
observation.satsIds = satsIds;
observation.dopplers = dopplers;
