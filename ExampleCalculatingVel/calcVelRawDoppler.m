clear
addpath("LibDoppler\")
addpath("LibGnss\")
addpath("ExampleCalculatingVel\")
%%
dataPath = "Data/30_07_2021/";
readData;
selectGpsData;

%%
wavelength = 2.99792458e8/1.57542e9;

%%
times = unique(gpsData.roverObs.time);
n = length(times);
V = zeros(3, n);
for k = 1:n
    obs = getObservation(times(k), posData, gpsData);
    
    % Pre-processing
    obs = filterObs(obs);

    % Calculating
    V(:, k) = calculate_vel(obs.recPos, obs.satsPos, obs.satsVel, obs.dopplers', wavelength);
    
    if mod(k, 500) == 0
        fprintf("%.0f%%\n", k/n*100);
    end
end

Vpos = [diff(posData.xecef), diff(posData.yecef), diff(posData.zecef)];
V = V';

%%
figure
for i = 1:3
    subplot(3, 1, i)
    hold on
    % Removendo o primeiro elemento para sincronizar os sinais
    plot(V(2:end, i), DisplayName="Raw Doppler");
    plot(Vpos(:, i), DisplayName="Derivada da posição (.pos)")
    legend()
    grid()
end

