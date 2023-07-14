function v = calculate_vel(rec_pos, sats_pos, sats_vel, dopplers, wavelength)
    % Vetores LOS (por coluna)
    los = (sats_pos - rec_pos)./vecnorm(sats_pos - rec_pos);
    
    % Escolhendo pivo
    pivo_idx = length(dopplers);
    pivo_vel = sats_vel(:, pivo_idx);
    pivo_los = los(:, pivo_idx);
    pivo_doppler = dopplers(:, pivo_idx);
    
    % Removendo pivo
    remove_column = @(x, j) x(:,[1:j-1, j+1:end]);
    sats_vel = remove_column(sats_vel, pivo_idx);
    los = remove_column(los, pivo_idx);
    dopplers = remove_column(dopplers, pivo_idx);
    
    % Montando o sistema
    Phi = (pivo_los-los)';
    b = wavelength*(pivo_doppler-dopplers) + dot(pivo_vel, pivo_los) - dot(sats_vel, los);
    b = b';
    
    % Resolvendo por LS
    v = Phi\b;  
end