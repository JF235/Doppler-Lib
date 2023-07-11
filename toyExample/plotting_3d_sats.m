% Plotando

ORANGE_C = "#D95319";
BLUE_C = "#0072BD";

% Plotando receptor
% Posição do receptor
plot3(rec_pos(1), rec_pos(2), rec_pos(3), ...
    'x', Color=BLUE_C, DisplayName="Receiver");
hold on
% Velocidade do receptor
vel_scale = 2;
v = rec_vel/vecnorm(rec_vel); 
quiver3(rec_pos(1), rec_pos(2), rec_pos(3), v(1), v(2), v(3), vel_scale, ...
    Color=BLUE_C);

% Plotando satélites
for k = 1:n_sats
    % Posição do satélite
    plot3(sats_pos(1, k), sats_pos(2, k), sats_pos(3, k), ...
        'o', MarkerEdgeColor=ORANGE_C, MarkerFaceColor=ORANGE_C, DisplayName="Satelite");
    
    % Vetor velocidade
    v = [sats_vel(1, k), sats_vel(2, k), sats_vel(3, k)];
    v = v/vecnorm(v);
    quiver3(sats_pos(1, k), sats_pos(2, k), sats_pos(3, k), v(1), v(2), v(3), vel_scale, ...
        Color=ORANGE_C);
end

xlim([-1, 11]);
ylim([-1, 11]);
zlim([-1, 11]);
grid()