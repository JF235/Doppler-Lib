%% Reading Data
dinfo = dir(fullfile(dataPath + "gnssData.mat"));
filenames = fullfile({dinfo.folder}, {dinfo.name});

% Encontrou gnssData.mat salvo
if length(filenames) == 1
    load(dataPath + "gnssData.mat");

% Não encontrou gnssData.mat
else
    % Nav
    groundEphemeris = readRinexNav(dataPath + "ground.nav");
    roverEphemeris = readRinexNav(dataPath + "rover.nav");
    % Obs
    [groundInitPos, groundObs, groundInterval] = readRinexObs(dataPath + "ground.obs");
    [roverInitPos, roverObs, roverInterval] = readRinexObs(dataPath + "rover.obs");
    % Pos
    [posData, ti, tf, freqGnss] = readPos(dataPath + "rover.pos");
    posData(:, 1) = round(posData(:, 1)); % posData.time == posData(:, 1)
    
    save(dataPath + "gnssData.mat");
end

clear dinfo filenames