addpath("data\30_07_2021\")
addpath("gnssLib\")

%% Arquivo .nav 
% Dados de órbitas das constelações e dos satélites
% (conteúdo de ambos é para ser igual)
groundEphemeris = readRinexNav("ground.nav");
roverEphemeris = readRinexNav("rover.nav");

%% Arquivo .obs
% Arquivos das observações: pseudorange, doppler, fase
[groundInitPos, groundObs, groundInterval] = readRinexObs("ground.obs");
[roverInitPos, roverObs, roverInterval] = readRinexObs("rover.obs");
groundObs = obs2table(groundObs);
roverObs = obs2table(roverObs);

%% Arquivo .pos
% Já foi processado no modo diferencial e produz uma solução
[gnss, ti, tf, freqGnss] = readPos("rover.pos");
gnss = pos2table(gnss);

% Plotting
plot3(gnss.lat, gnss.lon, gnss.alt, '.-');
grid();