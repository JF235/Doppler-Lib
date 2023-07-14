function [satPos,E,a,satVel]=satPosition(nav,time)
%% Broadcasted GPS Satellite Orbit Parameters
% keplerArray(1)  = svprn;
% keplerArray(2)  = af2;
% keplerArray(3)  = M0;
% keplerArray(4)  = roota;
% keplerArray(5)  = deltan;
% keplerArray(6)  = ecc;
% keplerArray(7)  = omega;
% keplerArray(8)  = cuc;
% keplerArray(9)  = cus;
% keplerArray(10) = crc;
% keplerArray(11) = crs;
% keplerArray(12) = i0;
% keplerArray(13) = idot;
% keplerArray(14) = cic;
% keplerArray(15) = cis;
% keplerArray(16) = Omega0;
% keplerArray(17) = Omegadot;
% keplerArray(18) = toe;
% keplerArray(19) = af0;
% keplerArray(20) = af1;
% keplerArray(21) = week_toe;
% keplerArray(22) = tgd;
% keplerArray(23) = txTime;
% keplerArray(24) = toc;
%% Constants
mu=3986004.418e8;% gravitational constant (m^3/s^2)
we=7292115.1467e-11; %Earth rotation rate (rad/s)
%c=2.99792458e8; %Speed of light in vacuum (m/s)
%% Nav Message Parameters
toe=nav(18);    %time of ephemeris
M0=nav(3);      %mean anomaly
sqrta=nav(4);   %semi major-axis square-root
a=sqrta^2;      %semi-major axis
deltan=nav(5);  %mean motion difference
ecc=nav(6);     %satellite orbit eccentricity
omega=nav(7);   %argument of perigee
cuc=nav(8);     %cos lat arg correction
cus=nav(9);     %sin lat arg correction
crc=nav(10);    %cos orbital radius correction
crs=nav(11);    %sin orbitatl radius correction
i0=nav(12);     %inclination at reference epoch (toe)
doti0=nav(13);  %rate of inclination angle
cic=nav(14);    %cos inclination correction
cis=nav(15);    %sin inclination correction
Omega0=nav(16); %Ascending node's right ascension
dotOmega=nav(17); %Rate of node's right ascension
%% Elapsed time (<4h)
tk=time-toe;
%it is sometimes necessary to apply a ±604,800-second correction when
%the two times straddle the week crossover.
if tk>302400
    tk=tk-604800;
elseif tk<-302400
    tk=tk+604800;
end
%1week = 604800s
%% Compute the mean anomaly
wis=sqrt(mu/a^3); %mean angular rate of the satellites orbital motion
M=M0+(wis+deltan)*tk;

%% Solve (iteratively) the Kepler equation
E=M;
iter=1;
iterMax=100;
while abs(E-M-ecc*sin(E))>1e-15 && iter<=iterMax
    %Newton-Rapshon's method
    iter=iter+1;
    if iter>iterMax
        error('Max Iteration exceeded!')
    end
    E=E-(E-ecc*sin(E)-M)/(1-ecc*cos(E));
end

%% Compute the true anomaly
v=atan2(sqrt(1-ecc^2)*sin(E)/(1-ecc*cos(E)),(cos(E)-ecc)/(1-ecc*cos(E)));
phi=omega+v;

%% Compute the argument of latitude
uk=phi+cuc*cos(2*phi)+cus*sin(2*phi);

%% Compute the radial distance
rk=a*(1-ecc*cos(E))+crc*cos(2*phi)+crs*sin(2*phi);

%% Compute the inclination
ik=i0+doti0*tk+cic*cos(2*phi)+cis*sin(2*phi);

%% Compute the longitude of the ascending node
lambdak=Omega0+(dotOmega-we)*tk-we*toe;

%% Compute the coordinates in the TRS (ECEF) frame
C=rotZ(-lambdak)*rotX(-ik)*rotZ(-uk);
satPos=C*[rk;0;0];
%% Compute satellite velocity
%Grooves pg338
dotE=(wis+deltan)/(1-ecc*cos(E));
dotPhi=sin(v)/sin(E)*dotE;

dotRos=(a*ecc*sin(E))*dotE+2*(crs*cos(2*phi)-crc*sin(2*phi))*dotPhi;
dotUos=(1+2*cus*cos(2*phi)-2*cuc*sin(2*phi))*dotPhi;

xos=rk*cos(uk);
yos=rk*sin(uk);
zos=0;

dotXos=dotRos*cos(uk)-rk*dotUos*sin(uk);
dotYos=dotRos*sin(uk)+rk*dotUos*cos(uk);
dotZos=0;

dotI=doti0+2*(cis*cos(2*phi)-cic*sin(2*phi))*dotPhi;

vex=dotXos*cos(lambdak)-dotYos*cos(ik)*sin(lambdak)+dotI*yos*sin(ik)*sin(lambdak);
vey=dotXos*sin(lambdak)+dotYos*cos(ik)*cos(lambdak)-dotI*yos*sin(ik)*cos(lambdak);
vez=dotYos*sin(ik)+dotI*yos*cos(ik);

vex=vex+(we-dotOmega)*(xos*sin(lambdak)+yos*cos(ik)*cos(lambdak));
vey=vey+(we-dotOmega)*(-xos*cos(lambdak)+yos*cos(ik)*sin(lambdak));

satVel=[vex;vey;vez];
