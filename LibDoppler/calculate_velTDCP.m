function [v, res, t] = calculate_velTDCP(k, posData, gpsData)
    %codegen    
    wavelength = 2.99792458e8/1.57542e9;
    obs = getObservationTDCP(k, posData, gpsData);
    [v, res] = calculate_vel(obs.recPos, obs.satsPos, obs.satsVel, ...
                                 obs.dopplers', wavelength);
    t = obs.time;
end