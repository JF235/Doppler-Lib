function [observation] = getObservation(T, posData, gpsData)
    % Selecionando dados em um determinado tempo
    % 1. Posição do receptor (.pos)
    % 2. Posições dos satélites (.nav > Ephemeris GPS)
    % 3. Velocidades dos satélites (.nav > Ephemeris GPS)
    % 4. Comprimento de onda dos satélites (Constante)
    % 5. Efeito Doppler de cada satélite (.obs > Rover)
    % 6. Fase de cada satélite (.obs > Rover)

    % 1. Posição do receptor (.pos)

    recPos = [ posData.xecef(posData.time == T);
                posData.yecef(posData.time == T);
                posData.zecef(posData.time == T) ];
    
    % 2 e 3. Posição e velocidade dos satélites (.nav > Ephemeris GPS)
    
    % Selecionandos os satélites...
    roverObs_gps = gpsData.roverObs;
    roverObsT = roverObs_gps(roverObs_gps.time == T, :);
    satsIds = roverObsT.satID;
    noSats = length(satsIds);
    
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
    
    % 5. e 6. Doppler e Fase de cada satélite
    % Raw Doppler e TDCP
    dopplers = roverObsT.doppler;
    phases = roverObsT.phase;
    
    % Empacotando informação
    observation.time = T;
    observation.recPos = recPos;
    observation.satsPos = satsPos;
    observation.satsVel = satsVel;
    observation.satsIds = satsIds;
    observation.dopplers = dopplers;
    observation.phases = phases;

end