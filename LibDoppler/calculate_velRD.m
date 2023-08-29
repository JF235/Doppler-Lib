function [v, res, t] = calculate_velRD(k, posData, gpsData)
    %codegen    
    wavelength = 2.99792458e8/1.57542e9;

    times = unique(gpsData.roverObs(:, 2));
    obs = getObservation(times(k), posData, gpsData);
    obs = filterObs(obs);
        
    [v, res] = calculate_vel(obs.recPos', obs.satsPos, obs.satsVel, ...
                                 obs.dopplers', wavelength, -1);
    t = obs.time;
end