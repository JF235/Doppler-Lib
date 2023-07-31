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
    
    % Converting to table
    groundObs = obs2table(groundObs);
    roverObs = obs2table(roverObs);
    posData = pos2table(posData);

    % Converting to struct
%     groundObs = table2struct(groundObs,"ToScalar",true);
%     roverObs = table2struct(roverObs,"ToScalar",true);
%     posData = table2struct(posData,"ToScalar",true);


    save(dataPath + "gnssData.mat");
end

clear dinfo filenames