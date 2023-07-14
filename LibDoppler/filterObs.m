function observation = filterObs(observation)
    % Remove observações com potenciais problemas.
    % Critérios:
    % 1. Doppler = 0
    % 2. Phase = 0
    
    idxs = find(observation.dopplers == 0);
    idxs = [idxs; find(observation.phases == 0)];
    idxs = unique(idxs);
    if ~isempty(idxs)
        observation.dopplers(idxs) = [];
        observation.phases(idxs) = [];
        observation.satsIds(idxs) = [];
        observation.satsPos(:, idxs) = []; 
        observation.satsVel(:, idxs) = [];
    end
end
