addpath("dopplerLib\")

c = 100; % speed of light

% Carrega informacoes dos satelites e do receptor
% Posição, velocidade, frequência e número de satélites
load_data

% Obtém as frequências recebidas pelo receptor após
% simular o desvio Doppler percebido.
simulate_dopplerShift

plotting_3d_sats

% Doppler shift vector
dopplers = f_received - f_sat;
wavelength = c/f_sat;

v = calculate_vel(rec_pos, sats_pos, sats_vel, dopplers, wavelength);

if vecnorm(v - rec_vel) < 1e-9
    fprintf("Resultado correto.\n")
end

