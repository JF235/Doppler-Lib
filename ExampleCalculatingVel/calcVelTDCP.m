clear
addpath("LibDoppler\")
addpath("LibGnss\")
addpath("ExampleCalculatingVel\")

%%
dataPath = "Data/09_02_2022/";
readData;
selectGpsData;

%%
wavelength = 2.99792458e8/1.57542e9;

%%
times = unique(gpsData.roverObs.time);
n = length(times);
V_RD = zeros(3, n);
V_TDCP = zeros(3, n);
T = zeros(1, n);

for k = 2:n-1
    
    % Observações do temo t(k-1), t(k) e t(k+1)
    obs_prev = getObservation(times(k-1), posData, gpsData);
    obs = getObservation(times(k), posData, gpsData);
    obs_next = getObservation(times(k+1), posData, gpsData);

    % Pre-processamento (removendo medidas com valor 0)
    obs_prev = filterObs(obs_prev);
    obs = filterObs(obs);
    obs_next = filterObs(obs_next);
    
    % Selecionando dados válidos
    % O satélite deve ter medidas nos três tempos t(k-1), t(k), t(k+1)
    sats_prev = obs_prev.satsIds;
    sats = obs.satsIds;
    sats_next = obs_next.satsIds;
    
    sats = intersect(sats, sats_prev, 'stable');
    sats = intersect(sats, sats_next, 'stable');
    
    % Iniciando nova observação
    newObs.recPos = obs.recPos;
    newObs.satsIds = sats;
    newObs.time = obs.time;

    % Selecionando dados dos satélites válidos
    satsPos = [];
    satsVel = [];
    dopplers = [];
    for satNo = sats'
        satMask = obs.satsIds == satNo;
        satsPos = [satsPos, obs.satsPos(:, satMask)];
        satsVel = [satsVel, obs.satsVel(:, satMask)];
        phase_prev = obs_prev.phases(obs_prev.satsIds == satNo);
        phase_next = obs_next.phases(obs_next.satsIds == satNo);
        dopp = -(phase_next - phase_prev)/(obs_next.time - obs_prev.time);
        dopplers = [dopplers; dopp];
    end
    newObs.satsPos = satsPos;
    newObs.satsVel = satsVel;
    newObs.dopplers = dopplers;


    % Calculating
    V_TDCP(:, k) = calculate_vel(newObs.recPos, newObs.satsPos, newObs.satsVel, newObs.dopplers', wavelength);
    V_RD(:, k) = calculate_vel(obs.recPos, obs.satsPos, obs.satsVel, obs.dopplers', wavelength);
    T(k) = obs.time;

    if mod(k, 500) == 0
        fprintf("%.0f%%\n", k/n*100);
    end
end

Vpos = [diff(posData.xecef), diff(posData.yecef), diff(posData.zecef)];
V_TDCP = V_TDCP';
V_RD = V_RD';

%%
figure
for j = 1:3
    subplot(3, 1, j)
    %%
    hold on
    plot(T(2:end-1), V_RD(2:end-1, j), DisplayName="Raw Doppler", LineWidth=1.5);
    plot(T(2:end-1), V_TDCP(2:end-1, j), DisplayName="TDCP", LineWidth=1.5);

    % Removendo o primeiro elemento para sincronizar os sinais
    plot(posData.time(1:end-1), Vpos(:, j), DisplayName="Derivada da posição (.pos)", LineWidth=1.5)
    
    legend()
    grid()
end
