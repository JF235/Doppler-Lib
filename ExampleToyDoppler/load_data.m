% Receiver
rec_pos = [0; 0; 0];
rec_vel = [5; -4; 1];

% Satelites
s1_pos = [10; 0; 0]; s1_vel = [12; 12; 16];
s2_pos = [0; 10; 0]; s2_vel = [-1; -2; -3];
s3_pos = [0; 0; 10]; s3_vel = [0; 0; -4];
s4_pos = [10; 10; 10]; s4_vel = [5; -4; 1];

sats_pos = [s1_pos, s2_pos, s3_pos, s4_pos];
sats_vel = [s1_vel, s2_vel, s3_vel, s4_vel];
n_sats = size(sats_pos, 2);  % size = (linhas, colunas)

f_sat = 235; % Hz