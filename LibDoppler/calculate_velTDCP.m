function [v, res, t] = calculate_velTDCP(k, posData, gpsData, Vpos)
    %codegen    
    wavelength = 2.99792458e8/1.57542e9;

    % TDCP
    obs = getObservationTDCP(k, posData, gpsData);
    [v, res] = calculate_vel(obs.recPos, obs.satsPos, obs.satsVel, ...
                                 obs.dopplers', wavelength, 1);
    
    % RD
%     times = unique(gpsData.roverObs(:, 2));
%     obs = getObservation(times(k), posData, gpsData);
%     obs = filterObs(obs);
%     [v_rd, ~] = calculate_vel(obs.recPos', obs.satsPos, obs.satsVel, ...
%                                  obs.dopplers', wavelength, 1);


    % Corrigindo velocidade baseando-se na velocidade obtida a partir da
    % posição.
    habilitarCorrecao = 1;
    if habilitarCorrecao
        % Vpos
        v_dpdt = Vpos(k,:);
        
        if norm(v - v_dpdt') > 1
            v = v_dpdt';
        end 
    end

    t = obs.time;
end