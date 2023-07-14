function table = obs2table(obs)
    % Transforma uma matriz com os dados do .OBS em uma tabela.
    table = array2table(obs);
    table.Properties.VariableNames(1:end) = {'week', 'time',... 
        'constID', 'satID', 'pseudorange', 'rangeLLI', 'rangeStrength',... 
        'phase', 'phaseLLI', 'phaseStrength', 'doppler', 'SNR'};
end