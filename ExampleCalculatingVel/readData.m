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
    groundObs = obs2table(groundObs);
    roverObs = obs2table(roverObs);
    % Pos
    [posData, ti, tf, freqGnss] = readPos(dataPath + "rover.pos");
    posData = pos2table(posData);
    posData.time = round(posData.time);
    save(dataPath + "gnssData.mat");
end

clear dinfo filenames