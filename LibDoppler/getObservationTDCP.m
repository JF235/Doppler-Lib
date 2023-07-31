function obsTDCP = getObservationTDCP(k, posData, gpsData)
    % Observações do temo t(k-1), t(k) e t(k+1)
    times = unique(gpsData.roverObs(:, 2));
    obs_prev = getObservation(times(k-1), posData, gpsData);
    obs = getObservation(times(k), posData, gpsData);
    obs_next = getObservation(times(k+1), posData, gpsData);

    % Pre-processamento (removendo medidas com valor 0)
    obs_prev = filterObs(obs_prev);
    obs = filterObs(obs);
    obs_next = filterObs(obs_next);

    % Selecionando satélites válidos.
    % Sat. deve estar disponível em  t(k-1), t(k), t(k+1)
    sats_prev = obs_prev.satsIds;
    sats = obs.satsIds;
    sats_next = obs_next.satsIds;
    
    sats = intersect(sats, sats_prev, 'stable');
    sats = intersect(sats, sats_next, 'stable');

    % Observação para processamento TDCP
    obsTDCP.recPos = obs.recPos';
    obsTDCP.satsIds = sats;
    obsTDCP.time = obs.time;

    % Selecionando dados dos satélites válidos
    satsPos = [];
    satsVel = [];
    dopplers = [];
    for k = 1:length(sats)
        satNo = sats(k);
        satMask = obs.satsIds == satNo;
        satsPos = [satsPos, obs.satsPos(:, satMask)];
        satsVel = [satsVel, obs.satsVel(:, satMask)];
        phase_prev = obs_prev.phases(obs_prev.satsIds == satNo);
        phase_next = obs_next.phases(obs_next.satsIds == satNo);
        doppTDCP = -(phase_next - phase_prev)/(obs_next.time - obs_prev.time);
        dopplers = [dopplers; doppTDCP];
    end
    obsTDCP.satsPos = satsPos;
    obsTDCP.satsVel = satsVel;
    obsTDCP.dopplers = dopplers;
end