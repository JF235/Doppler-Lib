radial_vel = zeros(1, n_sats);
los = (sats_pos - rec_pos)./vecnorm(sats_pos - rec_pos);
rel_vel = sats_vel - rec_vel;
radial_vel = dot(rel_vel, los);

% radial_vel < 0 (satelite aproximando), f_received > f_sat 
%            > 0 (satelite afastanto),   f_received < f_sat

% Doppler effect
f_received = f_sat*(1-radial_vel/c);